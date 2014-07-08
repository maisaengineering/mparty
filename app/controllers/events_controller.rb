class EventsController < ApplicationController
layout 'spree_application'
	def index
		@events = current_spree_user.events 
		@invited_events = []
	end
	
	def new
		@event = current_spree_user.events.build
	end

	def create
		@event = current_spree_user.events.build(event_params)
		if @event.save
			redirect_to event_path(@event)
		else
			render 'new'
		end

	end

	def show
		@event = Event.find(params[:id])
		@wish_lists = current_spree_user.wishlists.where(:is_private => 0)
	end

	def view_invitation
		invitation = Invite.find_by_token(params[:invitation_code])
		@event = invitation.event
		@invite_email = invitation.recipient_email
		@token = invitation.token
		render :layout => false
	end	

  def send_invitation
    emails = params[:friend_emails]
    e = emails.split(',')
    @event = Event.find(params[:event_id])
    e.each do |email|
    	@invite = Invite.create do |inv|
      		inv.event_id = @event.id
      		inv.invited_user_id = @event.user_id
      		inv.joined = 0
      		inv.recipient_email = email
      end
      Notifier.invite_friend(email, @invite).deliver
    end
  end

	private
		def event_params
			params.require(:event).permit(:name, :location, :description, :starts_at, :ends_at)
		end
end
