class Meeting < ActiveRecord::Base
  def project
  	issue.project;
  end
  def project=(p)
  	issue.project=p
  end
  def convacator
  	issue.assigned_to
  end
  def convacator=(user)
  	issue.assigned_to = user
  end
  def date
  	issue.start_date
  end
  def date=(d)
  	issue.start_date = d
  end
  def status
  	issue.status
  end
  def status=(s)
  	issue.status=s
  end
  has_many :internal_participants, :class_name => 'InternalParticipant', :dependent => :delete_all
  has_many :internal_participant_users, :through => :internal_participants, :class_name => 'User', :source => :user, :uniq => true
  validates_presence_of :date, :place, :subject, :project, :issue, :convacator, :status
  validates_length_of :subject, :maximum => 255
  validates_numericality_of :hours, :allow_nil => true
end
