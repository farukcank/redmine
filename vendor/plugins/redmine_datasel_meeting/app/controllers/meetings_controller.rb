class MeetingsController < ApplicationController
  unloadable
  before_filter :find_project
  before_filter :authorize

  verify :method => :post, :only => [:create, :update], :render => { :nothing => true, :status => :method_not_allowed }
  def index
	@meetings = Meeting.find(:all, :joins => "join issues on issues.id = meetings.issue_id", :conditions => ["project_id=?", @project.id], :order => 'date').reverse
  end

  def edit
	find_meeting
	@allowed_statuses = @meeting.issue.new_statuses_allowed_to(User.current)
  end
  
  def update
	Meeting.transaction do
		find_meeting
  		#@meeting.convacator = User.find params[:meeting][:convacator_id]
  		issue = @meeting.issue
  		issue.subject = @meeting.subject
  		issue.description = @meeting.agenda
  		issue.save!
  		if @meeting.update_attributes(params[:meeting])
  			redirect_to :action => 'show', :id => @project, :meeting_id => @meeting.id
  		else
  			render :action => 'edit'
  		end
		issue = @meeting.issue
                issue.save!
		InternalParticipantsController.setTimeEntriesOfMeeting!(@meeting)
	end
  end
  
  def create
	Meeting.transaction do
  		#@meeting.convacator = User.find params[:meeting][:convacator_id]
		issue = Issue.new :created_on => Time.now, :start_date => Time.now
		@meeting = Meeting.new
		@meeting.issue = issue	
		@meeting.attributes=params[:meeting]
  		issue.subject = @meeting.subject
  		issue.description = @meeting.agenda
  		issue.tracker_id = @project.datasel_meeting_tracker_id
		issue.project = @project
		issue.author = User.current
		#issue.assigned_to_id = @meeting.convacator_id
		issue.status = IssueStatus.default
		issue.priority_id = @project.datasel_meeting_priority_id
  		issue.save!
		InternalParticipantsController.addTimeEntryToUser!(@meeting, @meeting.convacator_id)
  		if @meeting.save
  			redirect_to :action => 'show', :id => @project, :meeting_id => @meeting.id
  		else
  			render :action => 'new'
			raise ActiveRecord::Rollback
  		end
		journal = Journal.new :notes => "{{meeting(#{@meeting.id})}}"
                journal.user = @meeting.convacator
                journal.journalized = issue
                journal.save!
	end
  end
  
  def new
  	@meeting = Meeting.new
  	@meeting.issue = Issue.new
  	@meeting.project = @project
  	@meeting.convacator = User.current
	@meeting.issue.tracker_id = @project.datasel_meeting_tracker_id
	@meeting.issue.priority_id = @project.datasel_meeting_priority_id
  	@meeting.date = Time.now
	@allowed_statuses = @meeting.issue.new_statuses_allowed_to(User.current)
  end

  def show
	find_meeting
  end

  def find_meeting
	@meeting = Meeting.find(params[:meeting_id])
        raise ActiveRecord::RecordNotFound unless @meeting.project == @project
  end
  private
  def find_project
    @project = Project.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @project
  end
end
