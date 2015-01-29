class VenuesController < ApplicationController
  def index
    @top_five = Venue.top_five
    @venues=Venue.advance_search(params[:query])
    if params[:query].present?
      @top_five= @top_five.to_a-@venues.to_a
    end
    if params[:city].present?
      @venues =  Venue.where("city = ?", params[:city]).to_a
      selected_rate__venues_array =  Venue.joins(:rating_cache).where("rating_caches.avg" => params[:rating]).to_a
      unless selected_rate__venues_array.blank?
        selected_rate__venues_array.each do |venue_obj|
          @venues << venue_obj
        end
      end
      @top_five= @top_five.to_a-@venues
      flash.now[:notice] = "Please select another venue."
    end
    flash.now[:error] = "No results found for '#{params[:query]}'" if params[:query] and  @venues.blank?
  end

  def show
    @venue = Venue.find(params[:id])
    @pictures = @venue.pictures
    @videos = @venue.video_urls
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
    @type_of_venues = @venue.venue_categories.map(&:venue_type).reject(&:empty?) if @venue.venue_categories.present?
  end 

  def check_availability
    @event = Event.new(session[:event_data])
    @venue = Venue.find(params[:id])
    #start_date = @event.starts_at
    start_date = Time.zone.local(@event.starts_at.year,@event.starts_at.month,@event.starts_at.day,@event.start_time.hour,@event.start_time.min,@event.start_time.sec)
    if @event.ends_at.present? && @event.end_time.present? 
      end_date = Time.zone.local(@event.ends_at.year,@event.ends_at.month,@event.ends_at.day,@event.end_time.hour,@event.end_time.min,@event.end_time.sec)
    else
      end_date = Time.zone.local(@event.starts_at.year,@event.starts_at.month,@event.starts_at.day,23,@event.start_time.min,@event.start_time.sec)
    end 
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
    has_events_with_venue = Event.past.where(:venue_id => venue.id, :user_id => user.id)
    past_events = Event.past.where(:venue_id => venue.id).ids
    has_invitation_with_venue = Invite.where(joined: 1, user_id: user.id, event_id: past_events)
    if ( has_events_with_venue.present? || has_invitation_with_venue.present? )
       has_ratings = user.ratings_given.where(dimension: nil, rateable_id: venue.id, rateable_type: venue.class.name).size.zero?
       return has_ratings ? true : false
    else
      return false
    end 

  end 
  
end
