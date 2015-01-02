class VenuesController < ApplicationController
  def index
    @top_five = Venue.top_five
    @venues = Venue.find_by_fuzzy_name(params[:query])
    flash.now[:error] = "No results found for '#{params[:query]}'" if params[:query] and  @venues.blank?
  end

  def show
    @venue = Venue.find(params[:id])
    @pictures = @venue.pictures
    if current_spree_user.present?
      @can_rate_it = check_permission_for_rate_it(@venue, current_spree_user)
    else
      @can_rate_it = false
    end  
    @reviews = @venue.reviews.order(created_at: :desc).page(params[:page]).per(4)
    @contact = @venue.venue_contacts.first
  end 

  def check_availability
    @event = Event.new(session[:event_data])
    @venue = Venue.find(params[:id])
    start_date = @event.starts_at
    end_date = @event.ends_at.present? ? @event.ends_at : start_date
    booked_venues_dates =  @venue.venue_calendars.where('(start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?) ', start_date,end_date,start_date,end_date)
    if !booked_venues_dates.present?
      @available = true      
    else      
      @available = false
    end
    render layout: false
  end

  def booked_slots
    @venue = Venue.find(params[:id])  
    if @venue.venue_calendars.present?
     @slots = @venue.venue_calendars
    end 
  end 

  def check_permission_for_rate_it(venue, user)
    invitation = Invite.where(joined: 1, user_id: user.id)
    venue_id = nil
    owner_venue_id = nil
    is_owner_of_event = Event.find_by_user_id(user.id)
    owner_venue_id = is_owner_of_event.venue_id if is_owner_of_event.present?
    venue_id = invitation.first.event.venue_id if invitation.present?
    if (owner_venue_id == venue.id) || (invitation.present? && venue_id == venue.id)
      return true
    else
      return false
    end  
  end 
end
