class MeetingsController < ApplicationController
  unloadable


  def index
	@project = Project.find(params[:project_id])
	@polls = Meeting.find(:all) # @project.polls
  end

  def edit
  end

  def new
  	@project = Project.find(params[:project_id])
  end

  def show
  end
end
