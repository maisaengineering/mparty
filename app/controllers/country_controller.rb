class CountryController < ApplicationController
  respond_to :json

  def get_states
    @country = Spree::Country.find_by_name(params[:country])
    @states = @country.states
    respond_with(@states)
  end

end
