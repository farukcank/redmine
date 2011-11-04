class Meeting < ActiveRecord::Base
  def project
  	self.issue.project;
  end
  def project=(p)
  	self.issue.project=p
  end
  def convacator
  	self.issue.assigned_to
  end
  def convacator=(user)
  	self.issue.assigned_to = user
  end
  def convacator_id
	self.issue.assigned_to_id
  end
  def convacator_id=(id)
	self.issue.assigned_to_id=id
  end
  def status
  	self.issue.status
  end
  def status=(s)
  	self.issue.status=s
  end
  def agenda
	self.issue.description
  end
  def agenda=(a)
	self.issue.description=a
  end
  def subject
	self.issue.subject
  end
  def subject=(s)
	self.issue.subject=s
  end
  belongs_to :issue, :class_name => 'Issue', :foreign_key => 'issue_id'
  has_many :internal_participants, :class_name => 'InternalParticipant', :dependent => :delete_all
  has_many :internal_participant_users, :through => :internal_participants, :class_name => 'User', :source => :user, :uniq => true
  validates_presence_of :date, :place, :subject, :project, :issue, :convacator, :status
  validates_length_of :subject, :maximum => 255
  validates_numericality_of :hours, :allow_nil => true
end
