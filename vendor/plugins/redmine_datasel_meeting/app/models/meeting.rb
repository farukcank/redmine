class Meeting < ActiveRecord::Base
  belongs_to :project, :class_name => 'Project', :foreign_key => 'project_id'
  belongs_to :convacator, :class_name => 'User', :foreign_key => 'convacator_id'  																  
  belongs_to :issue, :class_name => 'Issue', :foreign_key => 'issue_id'
  has_many :internal_participants, :class_name => 'InternalParticipant', :dependent => :delete_all
  has_many :internal_participant_users, :through => :internal_participants, :class_name => 'User', :source => :user, :uniq => true
  validates_presence_of :date, :place, :subject, :project, :issue, :convacator
  validates_length_of :subject, :maximum => 255
end
