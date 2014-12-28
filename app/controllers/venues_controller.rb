class VenuesController < ApplicationController
  def index
    @top_five = Venue.top_five
    @venues = Venue.find_by_fuzzy_name(params[:query])
    flash.now[:error] = "No results found for '#{params[:query]}'" if params[:query] and  @venues.blank?
  end

  def show
    @venue = Venue.find(params[:id])
    @venue_calendars = @venue.venue_calendars 
    if @venue_calendars.present?
     slots = []
     @venue_calendars.each do |vc|
      slots << "{datetime: new Date(#{vc.start_date.year}, #{vc.start_date.month}, #{vc.start_date.day})}" 
      slots << "{datetime: new Date(#{vc.end_date.year}, #{vc.end_date.month}, #{vc.end_date.day})}" 
     end
     @booked_slots = slots.uniq.join(',')
     puts "******************#{@booked_slots}"
    end  
    @pictures = @venue.pictures
    @reviews = @venue.reviews.order(created_at: :desc).page(params[:page]).per(4)
    @contact = @venue.venue_contacts.first
  end

  def check_availability
    @event = Event.new(session[:event_data])
    @venue = Venue.find(params[:id])
    booked_venues_dates =  @venue.venue_calendars.where('start_date >= ? AND end_date <= ?', @event.starts_at,@event.starts_at).exists?
    if !(booked_venues_dates)
      @available = true      
    else      
      @available = false
    end
    render layout: false
  end
end
