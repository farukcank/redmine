class InternalParticipantsController < ApplicationController
  unloadable
  def create
  	@meeting = Meeting.find(params[:meeting_id])
  	@internal_participant = InternalParticipant.new(params[:internal_participant])
  	@internal_participant.meeting = @meeting
	@internal_participant.invited = true
	@internal_participant.attended = true
  	@internal_participant.save
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
  def make_invited
  	@meeting = Meeting.find(params[:meeting_id])
	@internal_participant = @meeting.internal_participants.select{|p| p.id=params[:internal_participant_id]}.first
	@internal_participant.invited = true
	@internal_participant.save
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
  def make_uninvited
        @meeting = Meeting.find(params[:meeting_id])
        @internal_participant = @meeting.internal_participants.select{|p| p.id=params[:internal_participant_id]}.first
        @internal_participant.invited = false
        @internal_participant.save
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
