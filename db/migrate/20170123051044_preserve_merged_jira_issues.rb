class PreserveMergedJiraIssues < ActiveRecord::Migration
  def self.up
    add_column :jira_issues_and_pushes, :merged, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :jira_issues_and_pushes, :merged
  end
end
