class MeetingsController < ApplicationController
  unloadable


  def index
	@project = Project.find(params[:project_id])
	@meetings = Meeting.find(:all) # @project.polls
  end

  def edit
  end
  def create
  	@project = Project.find(params[:project_id])
  	@meeting = Metting.new(params[:meeting])
  	if @meeting.save
  		redirect_to :action => 'show', :project_id => @project, :meeting_id => @meeting.id
  	else
  		render :action => 'new'
  	end
  end
  def new
  	@project = Project.find(params[:project_id])
  end

  def show
  	@project = Project.find(params[:project_id])
  	@meeting = Meeting.find(params[:meeting_id])
  end
end
