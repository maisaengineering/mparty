class EventsController < ApplicationController
	before_filter :check_for_cancel, :only => [:create, :send_invitation]

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
				if params[:commit] == "Create"
					redirect_to events_path
				else
					@wish_lists = current_spree_user.wishlists.where(:is_private => 0)
					render 'add_guests'
				end	
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
    @event = Event.find(params[:event_id])
    if params[:friend_emails].present?
    	e = params[:friend_emails].split(',')
    	e.each do |email|
    		@invite = Invite.create do |inv|
      		inv.event_id = @event.id
      		inv.invited_user_id = @event.user_id
      		inv.joined = 0
      		inv.recipient_email = email
      	end
      	Notifier.invite_friend(email, @invite).deliver
    	end
    	flash[:notice] = "Successfully sent Invitation mail."
    	redirect_to events_path
    else
    	flash[:notice] = "Atleast one email is required to Invite."
    	render 'add_guests'
    end	
  end

  def add_guests
  	@event = Event.find(params[:event_id])
  end	

	private
		def event_params
			params.require(:event).permit(:name, :location, :description, :starts_at, :ends_at)
		end

		def check_for_cancel
  		if params[:commit] == "Cancel"
    		redirect_to events_path
  		end
		end
end
