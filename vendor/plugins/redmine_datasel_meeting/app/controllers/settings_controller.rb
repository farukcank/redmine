class SettingsController < ApplicationController
  unloadable
  before_filter :find_project
  before_filter :require_admin
  verify :method => :post, :render => {:nothing => true, :status => :method_not_allowed }
  def save
	@project.datasel_meeting_cross_project = params[:cross_project]
        @project.datasel_meeting_priority_id = params[:priority_id]
	@project.datasel_meeting_tracker_id = params[:tracker_id]
	@project.save!
	flash[:notice] = l(:notice_your_preferences_were_saved)
	redirect_to :controller => "projects", :action => 'settings', :tab => 'datasel_meeting', :id => @project
  end
  private
  def find_project
    @project = Project.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @project
  end
end
