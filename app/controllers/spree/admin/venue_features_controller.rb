class Spree::Admin::VenueFeaturesController < Spree::Admin::BaseController

  def index
    @venue_features = VenueFeature.all
  end

  def new
    @venue_features = VenueFeature.new
  end

  def create
    @venue_features = VenueFeature.new(venue_features_params)
    if @venue_features.save
      redirect_to admin_venue_features_url, notice: "Venue feature added successfully"
    else
      render 'new'
    end
  end

  def edit
    @venue_features = VenueFeature.find(params[:id])
  end

  def update
    @venue_features = VenueFeature.find(params[:id])
    respond_to do |format|
      if @venue_features.update(venue_features_params)
        format.html { redirect_to edit_admin_venue_feature_url(@venue_features), notice: "Successfully updated"}
        format.json {head :no_content}
      else
        format.html { render action: 'edit'}
        format.json { render json: @venue_features.errors,status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @venue_features = VenueFeature.find(params[:id])
    @venue_features.destroy
    respond_to do |format|
      format.html { redirect_to admin_venue_features_url, notice: "Successfully deleted" }
      format.json { head :no_content }
    end
  end

  private

  def venue_features_params
    params.require(:venue_feature).permit(:name)
  end

end