class Spree::Admin::BookingsController < Spree::Admin::ResourceController
  # authorize_resource :class => false

  def index
    @bookings = VenueCalendar.includes(:venue,:event,:requested_by).order('created_at DESC').page(params[:page]).per(10)
  end

  def show
    @booking = VenueCalendar.find(params[:id])
  end

  def update
    @venue_calendar = VenueCalendar.find(params[:id])
    @venue_calendar.update_attribute(:status, params[:status])
    @venue_calendar.update_attribute(:user_id, spree_current_user.id) #skip callbacks
    # Send an email to customer here
    redirect_to :back,notice: 'Updated successfully'

  end


  private

  def model_class
    VenueCalendar
  end
end