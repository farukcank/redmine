class InternalParticipantsController < ApplicationController
  unloadable
  before_filter :find_project
  before_filter :authorize
  verify :method => :post
  def create
	InternalParticipant.transaction do
  	@internal_participant = InternalParticipant.new(params[:internal_participant])
  	@internal_participant.meeting = @meeting
	@internal_participant.invited = true
	@internal_participant.attended = true
  	@internal_participant.save
	InternalParticipantsController.addTimeEntryToUser!(@meeting, @internal_participant.user_id)
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
  def make_invited
        process_internal_participant do |p|
                p.invited = true
		p.save!
        end
  end
  def make_uninvited
	process_internal_participant do |p|
		p.invited = false
		if p.attended
			p.save!
		else
			p.delete
		end
	end
  end
  def make_attended
	InternalParticipant.transaction do
        	process_internal_participant do |p|
                	p.attended = true
                	p.save!
			InternalParticipantsController.addTimeEntryToUser!(@meeting, p.user_id)
        	end
	end
  end
  def make_not_attended
        process_internal_participant do |p|
                p.attended = false
		InternalParticipantsController.removeTimeEntryFromUser!(@meeting, p.user_id)
		if p.invited
                	p.save!
		else
			p.delete
		end
        end
  end
  private
  def process_internal_participant
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
  def find_project
    @project = Project.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @project
    @meeting = Meeting.find(params[:meeting_id])
    raise ActiveRecord::RecordNotFound unless @meeting
    raise ActiveRecord::RecordNotFound unless @meeting.project == @project
  end
  def self.addTimeEntryToUser!(meeting, user_id)
                timeEntry = TimeEntry.new :activity_id => meeting.project.datasel_meeting_activity_id, :hours => meeting.hours, :created_on => Time.now, :spent_on => meeting.date
                timeEntry.user_id = user_id
                timeEntry.issue = meeting.issue
                timeEntry.save!
  end
  def self.removeTimeEntryFromUser!(meeting, user_id)
		cond = ARCondition.new
		cond << "#{TimeEntry.table_name}.issue_id = #{meeting.issue.id} and #{TimeEntry.table_name}.user_id = #{user_id}"
		timeEntries = TimeEntry.find(:all,:conditions => cond.conditions)
		timeEntries.each {|timeEntry| timeEntry.delete}
  end
  def self.setTimeEntriesOfMeeting!(meeting)
                cond = ARCondition.new
                cond << "#{TimeEntry.table_name}.issue_id = #{meeting.issue.id}"
                timeEntries = TimeEntry.find(:all,:conditions => cond.conditions)
                timeEntries.each {|timeEntry| timeEntry.delete}
		InternalParticipantsController.addTimeEntryToUser!(meeting,meeting.convacator_id)
		meeting.internal_participants.each {|p| InternalParticipantsController.addTimeEntryToUser!(meeting,p.user_id) if p.attended}
  end
end
