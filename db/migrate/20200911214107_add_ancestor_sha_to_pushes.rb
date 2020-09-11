class AddAncestorShaToPushes < ActiveRecord::Migration
  def self.up
    add_column :pushes, :ancestor_sha, :string, :null => false, :default => "master", :limit => 40

    add_index :commits_and_pushes, [:id], :unique => true, :name => 'PRIMARY_KEY'

    add_index :jira_issues_and_pushes, [:id], :unique => true, :name => 'PRIMARY_KEY'

    add_index :branches, [:id], :unique => true, :name => 'PRIMARY_KEY'

    add_index :pushes, [:id], :unique => true, :name => 'PRIMARY_KEY'

    add_index :commits, [:id], :unique => true, :name => 'PRIMARY_KEY'

    add_index :jira_issues, [:id], :unique => true, :name => 'PRIMARY_KEY'

    add_index :users, [:id], :unique => true, :name => 'PRIMARY_KEY'

    add_index :repositories, [:id], :unique => true, :name => 'PRIMARY_KEY'
  end

  def self.down
    remove_column :pushes, :ancestor_sha
  end
end
