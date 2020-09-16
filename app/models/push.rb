# frozen_string_literal: true

class Push < ActiveRecord::Base
  fields do
    status       :string,  limit: 32
    email_sent   :boolean, default: false

    timestamps
  end

  validates :status, inclusion: Github::Api::Status::STATES.map(&:to_s)

  has_many :commits_and_pushes, class_name: :CommitsAndPushes, inverse_of: :push, dependent: :destroy
  has_many :commits, through: :commits_and_pushes
  has_many :jira_issues_and_pushes, class_name: :JiraIssuesAndPushes, inverse_of: :push, dependent: :destroy
  has_many :jira_issues, through: :jira_issues_and_pushes

  belongs_to :head_commit, class_name: 'Commit', required: true
  belongs_to :branch, inverse_of: :pushes, required: true
  belongs_to :ancestor_ref, class_name: 'AncestorRef', required: true

  def self.create_from_github_data!(github_data)
    commit = Commit.create_from_github_data!(github_data)
    branch = Branch.create_from_git_data!(github_data.git_branch_data)
    AncestorRef.all.map do |ancestor_ref|
      push = Push.where(head_commit: commit, branch: branch, ancestor_ref: ancestor_ref).first_or_initialize
      push.status = Github::Api::Status::STATE_PENDING
      push.save!
      CommitsAndPushes.create_or_update!(commit, push)
      push.reload
    end
  end

  delegate :service_name, to: :ancestor_ref

  scope :with_jira_issue, ->(key) { joins(:jira_issues).where('jira_issues.key = ?', key) }
  scope :for_ancestor, ->(ancestor) { joins(:ancestor_ref).where('ancestor_refs.service_name = ?', ancestor) }
  scope :for_commit_and_ancestor, ->(commit, ancestor) do
    joins(:head_commit, :ancestor_ref).where('commits.sha = ? and ancestor_refs.service_name = ?', commit, ancestor)
  end

  def to_s
    "#{branch.name}/#{head_commit.sha}"
  end

  def jira_issues?
    jira_issues.any?
  end

  def jira_issue_keys
    jira_issues.map(&:key)
  end

  def jira_issues_with_errors?
    jira_issues_with_errors.any?
  end

  def jira_issues_with_errors
    jira_issues_and_pushes.with_errors
  end

  def jira_issues_with_unignored_errors?
    jira_issues_and_pushes.with_unignored_errors.any?
  end

  def commits_with_errors?
    commits_with_errors.any?
  end

  def commits_with_unignored_errors?
    commits_with_errors.with_unignored_errors.any?
  end

  def commits_with_errors
    commits_and_pushes.with_errors
  end

  def no_jira_commits
    commits_and_pushes.with_no_jira_tag
  end

  def no_jira_commits?
    no_jira_commits.any?
  end

  def errors?
    commits_with_errors? || jira_issues_with_errors?
  end

  def unmerged_jira_issues
    jira_issues_and_pushes.where(merged: false).map(&:jira_issue)
  end

  def deploy_types
    jira_issues.map(&:deploy_types).flatten.uniq
  end

  def long_migration?
    unmerged_jira_issues.any?(&:long_running_migration?)
  end

  def sorted_jira_issues
    unmerged_jira_issues.sort_by(&:key).reverse
  end

  def <=>(other)
    to_s <=> other.to_s
  end

  def compute_status!
    self.status = if commits_with_unignored_errors? || jira_issues_with_unignored_errors?
                    Github::Api::Status::STATE_FAILED
                  else
                    Github::Api::Status::STATE_SUCCESS
                  end
  end
end
