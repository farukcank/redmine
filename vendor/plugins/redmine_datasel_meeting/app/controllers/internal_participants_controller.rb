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
        process_internal_participant do |p|
                p.invited = true
		p.save
        end
  end
  def make_uninvited
	process_internal_participant do |p|
		p.invited = false
		if p.attended
			p.save
		else
			p.delete
		end
	end
  end
  def make_attended
        process_internal_participant do |p|
                p.attended = true
                p.save
        end
  end
  def make_not_attended
        process_internal_participant do |p|
                p.attended = false
		if p.invited
                	p.save
		else
			p.delete
		end
        end
  end
  private
  def process_internal_participant
        @meeting = Meeting.find(params[:meeting_id])
        puts params[:internal_participant_id]
        internal_participant = InternalParticipant.find(params[:internal_participant_id])
        if internal_participant.meeting != @meeting
                render_404
        end
	yield(internal_participant)
        respond_to do |format|
                format.html { redirect_to :controller => 'meetings', :action => 'show', :meeting_id => @meeting, :project_id => @meeting.project.id }
                format.js do
                        internal_participants = @meeting.internal_participants
                        render :update do |page|
                                page.replace_html "internalparticipants", :partial => 'meetings/internal_participants', :locals => {:meeting => @meeting}
                                if internal_participant.errors.empty?
                                        page << "$('internal_participant_user_id').value = ''"
                                end
                        end
                end
        end
  end
end
