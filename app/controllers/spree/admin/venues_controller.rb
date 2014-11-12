class Spree::Admin::VenuesController < Spree::Admin::BaseController
  #before_action :set_spree_admin_template, only: [:show, :edit, :update, :destroy]

  # GET /spree/admin/templates
  # GET /spree/admin/templates.json
  def index
    @venues = Venue.all
  end

  def new
    @venue = Venue.new
    @venue.venue_contacts.build
  end

  def create
    @venue = spree_current_user.venues.build(venue_params)
    if @venue.save
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
    @venue.pictures.create(picture_params)
    redirect_to add_photos_admin_venue_url(@venue), notice: 'Image uploaded successfully.'
  end


  def remove_photo
    @venue = Venue.find(params[:id])
    @picture = Picture.find(params[:picture_id])
    @picture.destroy
    redirect_to add_photos_admin_venue_path(@venue) , notice: 'Image removed successfully'
  end


  private
  def venue_params
    params.require(:venue).permit(:name, :description,:venue_type,:room_dimensions,:capacity,:price_min,
                                  :price_max,:address1,:address2 ,:city,:state,:country,:zip,
                                  :promote,:priority,:special_notes,venue_contacts_attributes: [:full_name,:mobile_number,:land_number, :_destroy, :id])
  end

  def picture_params
    params.require(:picture).permit(:image,:name)
  end
end
