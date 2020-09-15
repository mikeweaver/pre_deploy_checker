class CreateAncestorRefs < ActiveRecord::Migration
  def self.up
    create_table :ancestor_refs, id: :bigint do |t|
      t.string :ref, :null => false, :limit => 40, :required => true, :default => "master"
      t.string :service_name, :null => false, :limit => 255, :required => true
    end

    add_column :pushes, :ancestor_ref_id, :integer, :limit => 8, :null => false

    add_index :pushes, [:ancestor_ref_id], :name => 'on_ancestor_ref_id'
  end

  def self.down
    remove_column :pushes, :ancestor_ref_id

    drop_table :ancestor_refs

    remove_index :pushes, :name => :on_ancestor_ref_id rescue ActiveRecord::StatementInvalid
  end
end
