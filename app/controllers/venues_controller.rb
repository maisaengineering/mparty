class VenuesController < ApplicationController

  def new
    @venue = Venue.new
  end

  def  create
    @venue = spree_current_user.venues.build(venue_params)
    if @venue.save
      redirect_to @venue, notice: 'Venue was successfully created.'
    else
      render 'new'
    end
  end



  private
  def venue_params
    params.require(:venue).permit(:name, :description,:venue_type,:room_dimensions,:capacity,:price_min,
                                  :price_max,:location,:address1,:address2 ,:city,:state,:country,:zip,
                                  :contact_name,:contact_mobile,:contact_land)
  end
end
