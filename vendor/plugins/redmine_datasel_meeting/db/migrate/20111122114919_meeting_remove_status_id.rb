class MeetingRemoveStatusId < ActiveRecord::Migration
  def self.up
    remove_column :meetings, :status_id
  end

  def self.down
    add_column :meetings, :status_id, :integer, :null => true
  end
end
