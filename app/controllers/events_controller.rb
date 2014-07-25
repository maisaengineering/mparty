class EventsController < ApplicationController
	before_filter :check_for_cancel, :only => [:create, :send_invitation]
  before_filter :auth_user, except: [:view_invitation, :show, :event_wishlist]
  layout 'spree_application'

  helper 'spree/taxons'

	def index
		@events = current_spree_user.events
    @upcoming = @events.find(:all, :order => "starts_at asc", :conditions => ['starts_at >= ?', Date.today])
    @previous = @events.find(:all, :order => "starts_at desc", :conditions => ['starts_at < ?', Date.today])

    @all_events= Event.where("user_id = #{current_spree_user.id} OR id IN (#{Invite.where(recipient_email:current_spree_user.email).map(&:event_id).join(", ")})")
    @upcoming_all_events = @all_events.where('starts_at >= ?', Date.today).order("starts_at asc").all
    @previous_all_events = @all_events.where('starts_at < ?', Date.today).order("starts_at desc").all

    invited = Event.where(:id=>Invite.where(recipient_email: current_spree_user.email).map(&:event_id))
    @invited_upcoming = invited.find(:all, :order => "starts_at asc", :conditions => ['starts_at >= ?', Date.today])
    @invited_previous = invited.find(:all, :order => "starts_at desc", :conditions => ['starts_at < ?', Date.today])
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
       invitations = []
       e.each do |email|
          event_invitation = Invite.where(event_id: @event.id, recipient_email: email).first
          if event_invitation.nil?
            invite = Invite.create do |inv|
              inv.event_id = @event.id
              inv.invited_user_id = @event.user_id
              inv.joined = 0
              inv.recipient_email = email
              inv.has_wishlist = params[:add_wishlist] if params[:add_wishlist]
            end
            invitations << invite
          end
       end

      if params[:add_wishlist]== "1" && !@event.ship_address.present?
       flash[:notice] = "Please provide Shipping Address for your Wishlist." 
       render "/events/shipping_address"
      else 
        send_invitation_emails(invitations)
       flash[:notice] = "Successfully sent Invitation mail."
       redirect_to events_path
      end 

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

  def calendar

  end

  def remove_product_from_wishlist
    @wished_product = Spree::WishedProduct.find(params[:product_id])
    @wished_product.destroy
    redirect_to "/events/add_guests/#{@wished_product.wishlist.event_id}"
  end

  def add_ship_address
    @event = Event.find(params[:event_id])
    ship_address = Spree::Address.new do |sa|
        sa.firstname = params[:ship_address][:firstname]
        sa.lastname = params[:ship_address][:lastname]
        sa.address1 = params[:ship_address][:address1]
        sa.address2 = params[:ship_address][:address2]
        sa.city = params[:ship_address][:city]
        sa.zipcode = params[:ship_address][:zipcode]
        sa.phone = params[:ship_address][:phone]
        sa.country_id = params[:ship_address][:country_id]
        sa.state_id = params[:ship_address][:state_id]
      end
    if ship_address.save
      @event.shipping_address_id = ship_address.id
      @event.save
      invitations = Invite.where(:event_id => @event.id, :mail_sent => false)
      send_invitation_emails(invitations)
      flash[:notice] = "Shipping Address added successfully"
      redirect_to events_path
    else
      flash[:notice] = "Invalid Shipping Address" #ship_address.errors.messages
      render "/events/shipping_address"
    end  
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

    def send_invitation_emails(invitations)
      invitations.each do |inv|
       if Notifier.invite_friend(inv.recipient_email, inv).deliver
        inv.mail_sent = true
        inv.save
       end 
      end  
    end
      
end
