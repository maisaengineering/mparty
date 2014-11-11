class Spree::Csr::VenuesController < Spree::Admin::BaseController
  before_action :set_spree_admin_template, only: [:show, :edit, :update, :destroy]

  # GET /spree/admin/templates
  # GET /spree/admin/templates.json
  def index
    @venues = Venue.all
  end

end
