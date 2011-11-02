class MeetingsController < ApplicationController
  unloadable


  def index
	@project = Project.find(params[:project_id])
	@meetings = Meeting.find(:all) # @project.polls
  end

  def edit
  	@project = Project.find(params[:project_id])
  	@meeting = Meeting.find(params[:meeting_id])
  end
  
  def update
  	@project = Project.find(params[:project_id])
  	@meeting = Meeting.find(params[:meeting_id])
  	if @meeting.update_attributes(params[:post])
  		redirect_to :action => 'show', :project_id => @project, :meeting_id => @meeting.id
  	else
  		render :action => 'edit'
  	end
  end
  
  def create
  	@project = Project.find(params[:project_id])
  	@meeting = Meeting.new(params[:meeting])
  	@meeting.project = @project
  	issue = Issue.new :created_on => Time.now, :start_date => Time.now
  	issue.subject = @meeting.subject
  	issue.description = @meeting.agenda
  	issue.tracker = @project.trackers.find(:first)
	issue.project = @project
	issue.author = User.current
	issue.assigned_to = User.current
	issue.status = IssueStatus.default
	issue.priority = IssuePriority.all[0]
  	issue.save
  	@meeting.issue = issue
  	@meeting.convacator = User.current
  	if @meeting.save
  		redirect_to :action => 'show', :project_id => @project, :meeting_id => @meeting.id
  	else
  		render :action => 'new'
  	end
  end
  def new
  	@project = Project.find(params[:project_id])
  	@meeting = Meeting.new()
  	@meeting.date = Time.now
  end

  def show
  	@project = Project.find(params[:project_id])
  	@meeting = Meeting.find(params[:meeting_id])
  end
end
