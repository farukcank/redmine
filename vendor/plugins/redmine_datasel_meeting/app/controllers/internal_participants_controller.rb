class InternalParticipantsController < ApplicationController
  unloadable
  def create
  	@meeting = Meeting.find(params[:meeting_id])
  	@internal_participant = InternalParticipant.new(params[:internal_participant])
  	@internal_participant.meeting = @meeting
  	if !@internal_participant.save
  		puts 'Failed to save internal participant'
  	end
  	respond_to do |format|
      format.html { redirect_to :controller => 'meetings', :action => 'show', :meeting_id => @meeting, :project_id => @meeting.project.id }
      format.js do
        @internal_participants = @meeting.internal_participants
        render :update do |page|
          page.replace_html "internalparticipants", :partial => 'meetings/internal_participants', :locals => {:meeting => @meeting}
          if @meeting.errors.empty?
            page << "$('internal_participant_user_id').value = ''"
          end
        end
      end
    end
  end
end
