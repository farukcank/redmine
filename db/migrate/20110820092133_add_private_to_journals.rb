class AddPrivateToJournals < ActiveRecord::Migration
  def self.up
     add_column :journals, :private, :boolean, :default => false
  end

  def self.down
     remove_column :journals, :private
  end
end
