class AddMeetingSettingsToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :datasel_meeting_cross_project, :boolean, :null => true
    add_column :projects, :datasel_meeting_tracker_id, :integer, :null => true
    add_column :projects, :datasel_meeting_priority_id, :integer, :null => true
  end

  def self.down
    remove_column :projects, :datasel_meeting_cross_project
    remove_column :projects, :datasel_meeting_tracker_id
    remove_column :projects, :datasel_meeting_priority_id
  end
end
