class AddIssueCategorySharing < ActiveRecord::Migration
  def self.up
    add_column :issue_categories, :sharing, :string, :default => 'none', :null => false
    add_index :issue_categories, :sharing
  end

  def self.down
    remove_column :issue_categories, :sharing
  end
end
