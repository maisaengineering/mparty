class VenuesController < ApplicationController
  def index
    if params[:query].present?  # when search
      @venues = Venue.advance_search(params[:query])
      flash.now[:notice] =  @venues.blank? ? "No results found for '#{params[:query]}'"  : "Total #{@venues.count} results found for '#{params[:query]}'"
    elsif params[:venue_id].present? # when comes from get suggestions
      suggestible_venue = Venue.find(params[:venue_id])
      @venues =  Venue.where.not(id: suggestible_venue.id).basic_search(suggestible_venue.city,suggestible_venue.state)
      if session[:event_data].present?
        event = Event.new(session[:event_data])
        if event.starts_at and event.ends_at
          # remove not available venues if any
          @venues =  @venues.where.not(id: VenueCalendar.where.not(venue_id: suggestible_venue.id).reserved(event.starts_at,event.ends_at).map(&:venue_id))
        end
      end
      flash.now[:notice] =  @venues.blank? ? "No criteria matched please choose another venue or click on back to add custom address."  :
          "Total #{@venues.count} similar venues found and available on requested date"
    else # default top six
      @venues = Venue.top_five
    end
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
    @reviews = @venue.reviews.order(created_at: :desc)#.page(params[:page]).per(4)
    @contacts = @venue.venue_contacts
    if @contacts.present?
      @land_numbers = @contacts.map(&:land_number).reject(&:empty?)
      @mobile_numbers = @contacts.map(&:mobile_number).reject(&:empty?)
      @contact_emails = nil #need to add email column to venue_contacts table
    end
    @type_of_venues = @venue.venue_categories.map(&:venue_type).reject(&:empty?) if @venue.venue_categories.present?
    render layout: false if request.xhr?
  end

  def check_availability
    @event = Event.new(session[:event_data])
    @venue = Venue.find(params[:id])
    if @venue.venue_calendars.reserved(@event.starts_at,@event.ends_at).exists?
      @available = false
    else
      @available = true
    end
    render layout: false
  end

  def booked_slots
    @venue = Venue.find(params[:id])
    @slots = @venue.venue_calendars.booked.includes(:event)
  end

  def check_permission_for_rate_it(venue, user)
    has_events_with_venue = Event.past.where(:venue_id => venue.id, :user_id => user.id)
    past_events = Event.past.where(:venue_id => venue.id).ids
    has_invitation_with_venue = Invite.where(joined: 1, user_id: user.id, event_id: past_events)
    if ( has_events_with_venue.present? || has_invitation_with_venue.present? )
      has_ratings =  venue.reviews.where(user_id: user.id).count.zero?
      return has_ratings ? true : false
    else
      return false
    end
  end

end
