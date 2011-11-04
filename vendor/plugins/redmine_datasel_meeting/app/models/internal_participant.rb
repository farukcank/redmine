class InternalParticipant < ActiveRecord::Base
  unloadable
  belongs_to :meeting, :class_name => 'Meeting', :foreign_key => 'meeting_id'
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :meeting, :user
end
