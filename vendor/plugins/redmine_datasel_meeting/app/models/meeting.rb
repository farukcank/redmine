class Meeting < ActiveRecord::Base
  unloadable
  def project
  	self.issue.project if self.issue
  end
  def project=(p)
  	self.issue.project=p if self.issue
  end
  def convacator
  	self.issue.assigned_to if self.issue
  end
  def convacator=(user)
  	self.issue.assigned_to = user if self.issue
  end
  def convacator_id
	self.issue.assigned_to_id if self.issue
  end
  def convacator_id=(id)
	self.issue.assigned_to_id=id if self.issue
  end
  def status
  	self.issue.status if self.issue
  end
  def status=(s)
  	self.issue.status=s if self.issue
  end
  def status_id
        self.issue.status_id if self.issue
  end
  def status_id=(s)
        self.issue.status_id=s if self.issue
  end
  def agenda
	self.issue.description if self.issue
  end
  def agenda=(a)
	self.issue.description=a if self.issue
  end
  def subject
	self.issue.subject if self.issue 
  end
  def subject=(s)
	self.issue.subject=s if self.issue
  end
  belongs_to :issue, :class_name => 'Issue', :foreign_key => 'issue_id'
  has_many :internal_participants, :class_name => 'InternalParticipant', :dependent => :delete_all
  has_many :internal_participant_users, :through => :internal_participants, :class_name => 'User', :source => :user, :uniq => true
  validates_presence_of :date, :place, :subject, :project, :issue, :convacator, :status
  validates_length_of :subject, :maximum => 255
  validates_numericality_of :hours, :allow_nil => true
end
