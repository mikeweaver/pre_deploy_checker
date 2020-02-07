class AddEmailSentToPushes < ActiveRecord::Migration
  def self.up
    change_column :commits_and_pushes, :ignore_errors, :boolean, :default => false
    change_column :commits_and_pushes, :no_jira, :boolean, :null => false, :default => false

    change_column :jira_issues_and_pushes, :ignore_errors, :boolean, :default => false
    change_column :jira_issues_and_pushes, :merged, :boolean, :null => false, :default => false

    change_column :pushes, :email_sent, :boolean, :default => false
  end

  def self.down
    change_column :commits_and_pushes, :ignore_errors, :boolean, default: false
    change_column :commits_and_pushes, :no_jira, :boolean, default: false

    change_column :jira_issues_and_pushes, :ignore_errors, :boolean, default: false
    change_column :jira_issues_and_pushes, :merged, :boolean, default: false, null: false

    change_column :pushes, :email_sent, :boolean, default: false
  end
end
