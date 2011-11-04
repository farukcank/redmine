class MeetingsController < ApplicationController
  unloadable
  before_filter :find_project

  def index
	@meetings = Meeting.find(:all, :conditions =>["project_id=?", @project.id])
  end

  def edit
  	@meeting = Meeting.find(params[:meeting_id])
  	@meeting.convacator_id = @meeting.convacator.id
  end
  
  def update
  	@meeting = Meeting.find(params[:meeting_id])
  	#@meeting.convacator = User.find params[:meeting][:convacator_id]
  	issue = @meeting.issue
  	issue.subject = @meeting.subject
  	issue.description = @meeting.agenda
  	issue.save
  	if @meeting.update_attributes(params[:meeting])
  		redirect_to :action => 'show', :project_id => @project, :meeting_id => @meeting.id
  	else
  		render :action => 'edit'
  	end
  end
  
  def create
  	@meeting = Meeting.new(params[:meeting])
  	@meeting.project = @project
  	#@meeting.convacator = User.find params[:meeting][:convacator_id]
  	issue = Issue.new :created_on => Time.now, :start_date => Time.now
  	issue.subject = @meeting.subject
  	issue.description = @meeting.agenda
  	issue.tracker = @project.trackers.find(:first)
	issue.project = @project
	issue.author = User.current
	#issue.assigned_to_id = @meeting.convacator_id
	issue.status = IssueStatus.default
	issue.priority = IssuePriority.all[0]
  	issue.save
  	@meeting.issue = issue
  	if @meeting.save
  		redirect_to :action => 'show', :project_id => @project, :meeting_id => @meeting.id
  	else
  		render :action => 'new'
  	end
  end
  
  def new
  	@meeting = Meeting.new
  	@meeting.issue = Issue.new
  	@meeting.project = project
  	@meeting.convacator = User.current
  	@meeting.date = Time.now
  end

  def show
  	@meeting = Meeting.find(params[:meeting_id])
  end
  
  def find_project
    @project = Project.find(params[:id])
  end
end
