class Spree::Admin::VenueFacilitiesController < Spree::Admin::BaseController

  def index
    @venue_facilities = VenueFacility.all
  end

  def new
    @venue_facility = VenueFacility.new
  end

  def create
    @venue_facility = VenueFacility.new(venue_facility_params)
    if @venue_facility.save
      redirect_to admin_venue_facilities_url, notice: "Venue facility added successfully"
    else
      render 'new'
    end
  end

  def edit
    @venue_facility = VenueFacility.find(params[:id])
  end

  def update
    @venue_facility = VenueFacility.find(params[:id])
    respond_to do |format|
      if @venue_facility.update(venue_facility_params)
        format.html { redirect_to edit_admin_venue_facility_url(@venue_facility), notice: "Successfully updated"}
        format.json {head :no_content}
      else
        format.html { render action: 'edit'}
        format.json { render json: @venue_facility.errors,status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @venue_facility = VenueFacility.find(params[:id])
    @venue_facility.destroy
    respond_to do |format|
      format.html { redirect_to admin_venue_facilities_url, notice: "Successfully deleted" }
      format.json { head :no_content }
    end
  end

  private

  def venue_facility_params
    params.require(:venue_facility).permit(:name)
  end

end
