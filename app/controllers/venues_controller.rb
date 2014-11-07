class VenuesController < ApplicationController
  before_filter :auth_user ,except:  [:index,:show]

  def index
    @top_five = Venue.top_five
    @venues = Venue.search(params[:query])
  end

  def new
    @venue = Venue.new
  end

  def  create
    @venue = spree_current_user.venues.build(venue_params)
    if @venue.save
      redirect_to add_photos_venue_url(@venue), notice: 'Venue was successfully created.Upload photos'
     # render 'add_photos', notice: 'Venue was successfully created now add venue photos'
    else
      render 'new'
    end
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def add_photos
    @venue = Venue.find(params[:id])
  end


  private
  def venue_params
    params.require(:venue).permit(:name, :description,:venue_type,:room_dimensions,:capacity,:price_min,
                                  :price_max,:location,:address1,:address2 ,:city,:state,:country,:zip,
                                  :contact_name,:contact_mobile,:contact_land)
  end
end
