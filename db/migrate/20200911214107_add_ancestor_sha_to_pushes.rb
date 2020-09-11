class AddAncestorShaToPushes < ActiveRecord::Migration
  def self.up
    add_column :pushes, :ancestor_sha, :string, :null => false, :default => "master", :limit => 40
  end

  def self.down
    remove_column :pushes, :ancestor_sha
  end
end
