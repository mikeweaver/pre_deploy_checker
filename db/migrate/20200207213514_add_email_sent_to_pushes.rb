# frozen_string_literal: true

class AddEmailSentToPushes < ActiveRecord::Migration
  def self.up
    add_column :pushes, :email_sent, :boolean, :default => false
  end

  def self.down
    remove_column :pushes, :email_sent, :boolean, default: false
  end
end
