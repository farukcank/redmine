class CreateInternalParticipants < ActiveRecord::Migration
  def self.up
    create_table :internal_participants do |t|
      t.column :user_id, :integer
      t.column :meeting_id, :integer
    end
  end

  def self.down
    drop_table :internal_participants
  end
end
