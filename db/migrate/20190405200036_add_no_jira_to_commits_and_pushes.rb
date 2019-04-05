class AddNoJiraToCommitsAndPushes < ActiveRecord::Migration
  def self.up
    add_column :commits_and_pushes, :no_jira, :boolean, default: false, null: false
  end

  def self.down
    remove_column :commits_and_pushes, :no_jira
  end
end
