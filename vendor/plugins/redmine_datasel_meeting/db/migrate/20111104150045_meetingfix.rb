class Meetingfix < ActiveRecord::Migration
  def self.up
    add_column :meetings, :status_id, :integer, :default => 0, :null => false
    add_column :meetings, :hours, :float, :null => false
    remove_column :meetings, :project_id
    remove_column :meetings, :convacator_id
    remove_column :meetings, :agenda
    remove_column :meetings, :subject
    remove_column :meetings, :date
    add_column :internal_participants, :invited, :boolean, :default => 1, :null => false
    add_column :internal_participants, :attended, :boolean, :default => 1, :null => false    
  end

  def self.down
  	remove_column :meetings, :status_id
  	remove_column :meetings, :hours
    add_column :meetings, :subject, :string, :null => false
    add_column :meetings, :date, :datetime, :null => false
    add_column :meetings, :agenda, :text
    add_column :meetings, :content, :text
    add_column :meetings, :project_id, :integer, :null => false
    remove_column :internal_participants, :invited
    remove_column :internal_participants, :attended
  end
end
