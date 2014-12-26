class EventsController < ApplicationController
  before_filter :check_for_cancel, :only => [:create, :send_invitation]
  before_filter :auth_user, except: [:view_invitation, :show, :event_wishlist]
  before_filter :register_handlebars,only: [:update_designs,:show]
  layout 'spree_application',except: [:index,:new,:create,:add_guests,:add_products,:show,:view_invitation,:show_invitation,:invite_with_wishlist]

  helper 'spree/taxons'

  def index
=begin
    @events = current_spree_user.events
    @upcoming_all_events = @events.where("starts_at >= ? AND is_private = ?", Date.today, true).order(starts_at: :asc)
    @previous_all_events = @events.where("starts_at < ? AND is_private = ?", Date.today, true).order(starts_at: :desc)

    @public_events = Event.where(is_private: false)
    @invited_events = Event.where(:id=>Invite.where(recipient_email: current_spree_user.email).map(&:event_id))
=end


    params[:type] ||= 'upcoming'
    if current_spree_user.present?
      if  params[:type] == 'upcoming'

        #@events =Event.joins(:invites).where("invites.user_id=? OR invites.invited_user_id=? OR events.is_private=?",current_spree_user.id,current_spree_user.id,false)
      @events = Event.joins(:invites).where("invites.invited_user_id=?",current_spree_user.id).upcoming.uniq.page(params[:page]).per(4)
      elsif params[:type] == 'past'
      @events = Event.joins(:invites).where("invites.invited_user_id=?",current_spree_user.id).past.uniq.page(params[:page]).per(4)
      elsif params[:type] == 'invited'
      @events= Event.invited(current_spree_user.email).upcoming.page(params[:page]).per(4)
      end
    else


    @events = Event.send(params[:type]).page(params[:page]).per(4)
    end

    respond_to do |format|
      format.js
      format.html
    end
  end



  def new
    @venue = Venue.find(params[:venue_id]) if params[:venue_id].present?
    @event = current_spree_user.events.new(session[:event_data])
    @event_templates = Spree::Admin::Template.select(:id,:name)
  end

  def update_designs
    @template = Spree::Admin::Template.find(params[:template_id])
    @designs = @template.designs
  end

  def  select_venue
    # hold user entered data before moving to venue selection
    session[:event_data] = event_params
    render nothing: true
  end

  def create
    @event = current_spree_user.events.new(event_params)
    @event_templates = Spree::Admin::Template.select(:id,:name)

    # if @event.save
    #   session.delete(:event_data) if session[:event_data]
    #   if params[:commit] == "Create"
    #     redirect_to events_path
    #   else
    #     render 'add_guests'
    #   end
    # else
    #   render 'new'
    # end
  end

  def show
    @event = Event.find(params[:id])
    @wish_list = @event.wishlist
    @commentable = @event
    @comments = @commentable.comments.order(created_at: :desc).page(params[:page]).per(8)
    @comment = Comment.new
    @pictures = @event.pictures.build
    @event_template = Spree::Admin::Template.where(id: @event.template_id).first
    @event_design = @event_template.designs.where(id: @event.design_id).first if @event_template
  end



  def view_invitation
    @invitation = Invite.find_by_token(params[:invitation_code])
    if @invitation.present?
      @event = @invitation.event
      @invite_email = @invitation.recipient_email
      @token = @invitation.token
    else
      flash[:error] = "We are sorry Invitation not found."
      render
    end
  end

  def show_invitation
    @invitation = Invite.find_by_event_id_and_recipient_email(params[:event_id],current_spree_user.email)
    if @invitation.present?
      @event = @invitation.event
      @invite_email = @invitation.recipient_email
      @token = @invitation.token
    else
      flash[:error] = "We are sorry Invitation not found."
      render
    end
    # @wishlist = @event.wishlist
    # @commentable = @event
    # @comments = @commentable.comments
    # @comment = Comment.new
    # @imageable = @event
    # @pictures = @imageable.pictures
    # @picture = Picture.new
  end

  def invite_with_wishlist
    @event = Event.find(params[:event_id])
    @wished_products = @event.wishlist.wished_products if @event.wishlist
  end

  def send_invitation
    @event = Event.find(params[:event_id])
    @wish_list = Spree::Wishlist.find_by_event_id(@event.id)
    if params[:friend_emails].present?

      e = params[:friend_emails].split(',')
      invitations = []
      failed_emails = []
      e.each do |email|
        email.strip!
        event_invitation = Invite.where(event_id: @event.id, recipient_email: email).first
        if event_invitation.nil?
          invite = Invite.create do |inv|
            inv.event_id = @event.id
            inv.invited_user_id = @event.user_id
            inv.joined = 0
            existing_user = Spree::User.find_by_email(email)
            if existing_user.present?
              inv.user_id = existing_user.id
            end
            inv.recipient_email = email
            inv.has_wishlist = true if params[:add_wishlist].present?
          end
          invitations << invite
        else
          failed_emails << email
        end
      end

      #if params[:add_wishlist]== "1" && !@event.ship_address.present?
      #	flash[:notice] = "Please provide Shipping Address for your Wishlist."
      #	render "/events/shipping_address"
      #else
      if invitations.size > 0
        send_invitation_emails(invitations,@event)
        flash[:notice] = "Successfully sent Invitation mail."
      else
        flash[:notice] = "You have already sent #{@event.name} Invitaion to #{ failed_emails.join(',') }"
      end


      redirect_to event_path(@event)
      #end

    else
      flash[:notice] = "Atleast one email is required to Invite."
      redirect_to invite_with_wishlist_url(event_id: @event.id)
    end

  end

  def add_guests
    @event = Event.find(params[:event_id])
    @wish_list = Spree::Wishlist.find_by_event_id(@event.id)
  end

  def add_products
    @event = Event.find(params[:event_id])
    # Create wishlist if not exists
    @wishlist= @event.wishlist.nil?  ? Spree::Wishlist.create(event_id: params[:event_id], name: @event.name, user_id: spree_current_user.id) :  @event.wishlist
    session[:wishlist_id] = @wishlist.id
    @products = Spree::Product.all
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
      #invitations = Invite.where(:event_id => @event.id, :mail_sent => false)
      #send_invitation_emails(invitations)
      flash[:notice] = "Shipping Address added successfully"
      redirect_to "/events/#{@event.id}/add_products"
      #redirect_to events_path
    else
      flash[:notice] = "Invalid Shipping Address" #ship_address.errors.messages
      render "/events/shipping_address"
    end
  end

# Need to work on get friends email of fb user
# And Autopopulate for multiple emails for normal user.
  def fetch_friends

    @invitations = current_spree_user.invites.where("recipient_email LIKE ?", "%#{params[:term]}%").group("recipient_email").map(&:recipient_email)

    respond_to do |format|
      format.html
      format.json {
        render json: @invitations
      }
    end
  end

  private
  def event_params
    params.require(:event).permit(:name, :host_name,:venue_id,:friend_emails,
                                  :host_phone, :location, :description, :starts_at,
                                  :start_time, :ends_at, :end_time, :is_private,
                                  :city,:state,:country,:zip,
                                  :image, :template_id, :design_id, pictures_attributes: [:image])
  end

  def check_for_cancel
    if params[:commit] == "Cancel"
      redirect_to events_path
    end
  end

  def send_invitation_emails(invitations,event)
    invitations.each do |inv|
      if Notifier.invite_friend(inv.recipient_email, inv,event).deliver
        inv.mail_sent = true
        inv.save
      end
    end
  end

  def get_friends
    current_spree_user.get_friend_emails
  end

end
