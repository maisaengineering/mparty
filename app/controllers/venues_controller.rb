class VenuesController < ApplicationController
  def index
    @top_five = Venue.top_five
    @venues = Venue.find_by_fuzzy_name(params[:query])
    flash.now[:error] = "No results found for '#{params[:query]}'" if params[:query] and  @venues.blank?
  end

  def show
    @venue = Venue.find(params[:id])
  end

end