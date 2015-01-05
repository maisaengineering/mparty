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
      venue_ratings = @venue.rates.first(5)
      if venue_ratings.present?
        venue_ratings.each_with_index do |rate, index|
          if rate.rater_id == current_spree_user.id
            @rating_possition = index+1
          end  
        end  
      end  
    else
      @can_rate_it = false
    end  
    @reviews = @venue.reviews.order(created_at: :desc).page(params[:page]).per(4)
    @contacts = @venue.venue_contacts
    if @contacts.present?
      @land_numbers = @contacts.map(&:land_number).reject(&:empty?)
      @mobile_numbers = @contacts.map(&:mobile_number).reject(&:empty?)
      @contact_emails = nil #need to add email column to venue_contacts table
    end  
    @type_of_venues = @venue.venue_categories
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
    past_invitation = false
    if invitation.present?
       venue_id = invitation.first.event.venue_id
       past_invitation = true if invitation.first.event.starts_at < DateTime.now
    end    

    owner_venue_id = nil
    is_owner_of_event = Invite.where(invited_user_id: user.id)
    past_event = false
    if is_owner_of_event.present?
       owner_venue_id = is_owner_of_event.first.event.venue_id
       past_event = true if is_owner_of_event.first.event.starts_at < DateTime.now
    end   

    if (owner_venue_id == venue.id && past_event) || (invitation.present? && venue_id == venue.id && past_invitation)
      if user.ratings_given.where(dimension: nil, rateable_id: venue.id, rateable_type: venue.class.name).size.zero?
         return true
      else
         return false
      end   
    else
      return false
    end  
  end 

end
