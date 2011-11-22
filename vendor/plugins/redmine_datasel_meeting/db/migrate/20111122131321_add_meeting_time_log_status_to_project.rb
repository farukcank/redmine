class AddMeetingTimeLogStatusToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :datasel_meeting_time_log_status_id, :integer, :null => true
  end

  def self.down
    remove_column :projects, :datasel_meeting_time_log_status_id
  end
end
