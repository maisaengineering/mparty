class EventsController < ApplicationController
	before_filter :check_for_cancel, :only => [:create, :send_invitation]
  before_filter :auth_user, except: [:view_invitation, :show, :event_wishlist]
  layout 'spree_application'

  helper 'spree/taxons'

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
					render 'add_guests'
				end
			else
				render 'new'
			end
	end

	def show
		@event = Event.find(params[:id])
		@wish_lists = @event.wishlist
	end

	def view_invitation
		invitation = Invite.find_by_token(params[:invitation_code])
		@event = invitation.event
		@invite_email = invitation.recipient_email
		@token = invitation.token
	end	

  def send_invitation
    @event = Event.find(params[:event_id])
    @wish_list = Spree::Wishlist.find_by_event_id(@event.id)
    if params[:friend_emails].present?

    	e = params[:friend_emails].split(',')
    	e.each do |email|
    		@invite = Invite.create do |inv|
      		inv.event_id = @event.id
      		inv.invited_user_id = @event.user_id
      		inv.joined = 0
      		inv.recipient_email = email
      		inv.has_wishlist = params[:add_wishlist] if params[:add_wishlist]
      	end
      	Notifier.invite_friend(email, @invite).deliver
    	end
    	flash[:notice] = "Successfully sent Invitation mail."
    	redirect_to events_path
    else
    	flash[:notice] = "Atleast one email is required to Invite."
    	redirect_to "/events/add_guests/#{@event.id}"
    end	
  end

  def add_guests
  	@event = Event.find(params[:event_id])
  	@wish_list = Spree::Wishlist.find_by_event_id(@event.id)
  end	

  def add_products
  	@products = Spree::Product.all
  	session[:wishlist_id] = Spree::Wishlist.find_by_event_id(params[:event_id]).id
  	@taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
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
