class AddMeetingActivityIdToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :datasel_meeting_activity_id, :integer, :null => true
  end

  def self.down
    remove_column :projects, :datasel_meeting_activity_id
  end
end
