class InternalParticipantsController < ApplicationController
  unloadable
  def create
  	@meeting = Meeting.find(params[:meeting_id])
  	@internal_participant = InternalParticipant.new(params[:internal_participant])
  	respond_to do |format|
      format.html { redirect_to :controller => 'meetings', :action => 'show', :meeting_id => @meeting, :project_id => @meeting.project.id }
      format.js do
        @internal_participants = @meeting.internal_participants
        render :update do |page|
          page.replace_html "internalparticipants", :partial => 'meetings/internal_participants', :locals => {:meeting => @meeting}
          if @relation.errors.empty?
            page << "$('relation_delay').value = ''"
            page << "$('relation_issue_to_id').value = ''"
          end
        end
      end
    end
  end
end
