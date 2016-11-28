class AddSecretAndMigrationColumnToJiraIssue < ActiveRecord::Migration
  def self.up
    add_column :jira_issues, :secrets_modified, :text, :limit => 255
    add_column :jira_issues, :long_running_migration, :text, :limit => 255
  end

  def self.down
    remove_column :jira_issues, :secrets_modified
    remove_column :jira_issues, :long_running_migration
  end
end
