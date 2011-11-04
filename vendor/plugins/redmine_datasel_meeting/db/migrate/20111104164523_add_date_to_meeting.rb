class AddDateToMeeting < ActiveRecord::Migration
  def self.up
    add_column :meetings, :date, :datetime, :null => false
  end

  def self.down
    remove_column :meetings, :date
  end
end
