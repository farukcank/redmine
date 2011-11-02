class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.column :subject, :string, :null => false
      t.column :place, :string
      t.column :date, :datetime, :null => false
      t.column :external_participants, :string
      t.column :agenda, :text
      t.column :content, :text
      t.column :issue_id, :integer, :null => false
      t.column :convacator_id, :integer, :null => false
      t.column :project_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :meetings
  end
end
