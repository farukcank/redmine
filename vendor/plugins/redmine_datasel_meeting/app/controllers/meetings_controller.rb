class MeetingsController < ApplicationController
  unloadable
  before_filter :find_project

  def index
	@meetings = Meeting.find(:all, :joins => "join issues on issues.id = meetings.issue_id", :conditions => ["project_id=?", @project.id])
  end

  def edit
	find_meeting
  end
  
  def update
	Meeting.transaction do
		find_meeting
  		#@meeting.convacator = User.find params[:meeting][:convacator_id]
  		issue = @meeting.issue
  		issue.subject = @meeting.subject
  		issue.description = @meeting.agenda
  		issue.save
  		if @meeting.update_attributes(params[:meeting])
  			redirect_to :action => 'show', :id => @project, :meeting_id => @meeting.id
  		else
  			render :action => 'edit'
  		end
		issue = @meeting.issue
                issue.save!
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
  		issue.tracker = @project.trackers.find(:first)
		issue.project = @project
		issue.author = User.current
		#issue.assigned_to_id = @meeting.convacator_id
		issue.status = IssueStatus.default
		issue.priority = IssuePriority.all[0]
  		issue.save!
  		if @meeting.save
  			redirect_to :action => 'show', :id => @project, :meeting_id => @meeting.id
  		else
  			render :action => 'new'
			raise ActiveRecord::Rollback
  		end
	end
  end
  
  def new
  	@meeting = Meeting.new
  	@meeting.issue = Issue.new
  	@meeting.project = @project
  	@meeting.convacator = User.current
  	@meeting.date = Time.now
  end

  def show
	find_meeting
  end

  def find_meeting
	@meeting = Meeting.find(params[:meeting_id])
        raise ActiveRecord::RecordNotFound unless @meeting.project == @project
	print @meeting.subject
	print @meeting.convacator.name
	print '-----'
  end

  def find_project
    @project = Project.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @project
  end
end
