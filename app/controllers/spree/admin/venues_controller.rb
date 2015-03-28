class Spree::Admin::VenuesController < Spree::Admin::ResourceController
  #before_action :set_spree_admin_template, only: [:show, :edit, :update, :destroy]

  # GET /spree/admin/templates
  # GET /spree/admin/templates.json
  def index
   # @venues = current_spree_user.has_spree_role?(:admin) ? Venue.all : current_spree_user.venues
    @venues =   Venue.all.order(created_at: :desc)
  end

  def new
    @venue = Venue.new
    @venue.venue_contacts.build
    @venue.video_urls.build
  end

  def create
    @venue = spree_current_user.venues.build(venue_params)
    if @venue.save
      @venue.venue_category_ids = params[:venue][:venue_type]
      redirect_to add_photos_admin_venue_url(@venue), notice: 'Venue was successfully created.Upload photos'
      # render 'add_photos', notice: 'Venue was successfully created now add venue photos'
    else
      render 'new'
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])
    @venue.venue_category_ids = params[:venue][:venue_type]
    respond_to do |format|
      if @venue.update(venue_params)
        format.html { redirect_to edit_admin_venue_url(@venue), notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_photos
    @venue = Venue.find(params[:id])
  end

  def upload_photos
    @venue = Venue.find(params[:id])
    @picture = Picture.new({imageable_type: @venue.class.to_s,imageable_id: @venue.id}.merge!(picture_params))
    @picture.save
    redirect_to add_photos_admin_venue_url(@venue), notice: 'Image uploaded successfully.'
  end


  def remove_photo
    @venue = Venue.find(params[:id])
    @picture = Picture.find(params[:picture_id])
    @picture.destroy
    redirect_to add_photos_admin_venue_path(@venue) , notice: 'Image removed successfully'
  end

  def add_calendar
    @venue = Venue.find(params[:id])
    @events_without_venue = Event.upcoming.where(venue_id: nil,custom_event_type: nil).to_a
  end 

   def add_venue_seating_images
    @venue = Venue.find(params[:id])
  end

    def save_seating_images
    @venue = Venue.find(params[:id])
    @seating_pic = VenueSeatingType.new({venue_id: @venue.id}.merge!(seating_image_params))
    @seating_pic.save
    redirect_to add_venue_seating_images_admin_venue_path(@venue), notice: 'Seating type uploaded successfully.'
  end

  def remove_seating_photo
    @venue = Venue.find(params[:id])
    @seating_pic = VenueSeatingType.find(params[:venue_seating_type_id])
    @seating_pic.delete
    redirect_to add_venue_seating_images_admin_venue_url(@venue), notice: "Deleted seating arragement successfully"
  end
  # def book_venue
  #   @venue = Venue.find(params[:id])
  #   @venue.venue_calendars.create(venue_calendar_params)
  #   redirect_to add_calendar_admin_venue_url(@venue), notice: 'Your Slot Booked successfully.'     
  # end 
  def book_venue
   @venue = Venue.find(params[:id])

   @new_venue_calendar = @venue.venue_calendars.build(venue_calendar_params)
   @new_venue_calendar.status = 2
   @new_venue_calendar.user_id = current_spree_user.id
   if @new_venue_calendar.save
     #update_event = @new_venue_calendar.event
     #update_event.venue_id = @new_venue_calendar.venue_id
     #update_event.save(validate: false)
     redirect_to add_calendar_admin_venue_url(@venue), notice: 'Your Slot Booked successfully.'     
   else
     flash[:error] = @new_venue_calendar.errors.full_messages.to_sentence
     redirect_to add_calendar_admin_venue_url(@venue)
   end 
  end

  def remove_venue_slot
    @venue = Venue.find(params[:id])
    @venue_calendar = VenueCalendar.find(params[:calendar_id])
    notice = ""
    if @venue_calendar.event_id.nil?
       @venue_calendar.destroy
       notice = 'Slot removed successfully'
    else
       notice = "You can't delete this slot. An Event associated with this slot." 
    end        
    redirect_to add_calendar_admin_venue_url(@venue), notice: notice
  end  


  private
  def venue_params
    params.require(:venue).permit(:name, :description,:venue_type,:room_dimensions,:capacity,:price_min,
                                  :price_max,:address,:location ,:city,:state,:country,:zip,:email,
                                  :promote,:priority,:special_notes,venue_contacts_attributes: [:full_name,:mobile_number,:land_number, :_destroy, :id],
                                  video_urls_attributes: [:url, :image_url,:_destroy, :id],template_ids: [],feature_ids: [],facility_ids: [])
  end

  def picture_params
    params.require(:picture).permit(:image,:name)
  end

  def seating_image_params
    params.require(:venue_seating_type).permit(:name,:seating_image,:capacity_min,:capacity_max)
  end

  def venue_calendar_params
    params.require(:venue_calendar).permit(:start_date,:end_date, :event_id,:venue_id, :user_id)
  end

  def model_class
    Venue
  end  
end
