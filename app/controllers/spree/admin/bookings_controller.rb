class Spree::Admin::BookingsController < Spree::Admin::ResourceController
 # authorize_resource :class => false
  
  def index
    @bookings = VenueCalendar.includes(:venue,:event,:requested_by).page(params[:page]).per(10)
  end

  def show
    @booking = VenueCalendar.find(params[:id])
  end

  def update
    @venue_calendar = VenueCalendar.find(params[:id])
    if params[:status].eql?('2')
      @venue_calendar.update_attribute(:status, 2) # confirmed
    elsif params[:status].eql?('3')
      @venue_calendar.update_attribute(:status, 3) # rejected
      end
    redirect_to :back,notice: 'Updated successfully'

  end


  private

  def model_class
    VenueCalendar
  end
end