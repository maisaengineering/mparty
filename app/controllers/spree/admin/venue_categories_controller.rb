class Spree::Admin::VenueCategoriesController < Spree::Admin::BaseController

  def index
    @venue_categories = VenueCategory.all
  end

  def new
    @venue_category = VenueCategory.new
   end

  def create
    @venue_category = VenueCategory.new(venue_category_params)
    if @venue_category.save
      redirect_to admin_venue_categories_path, notice: 'Venue Category was successfully saved.'
     else
      render 'new'
    end
  end

  def edit
    @venue_category = VenueCategory.find(params[:id])
  end

  def update
    @venue_category = VenueCategory.find(params[:id])
    respond_to do |format|
      if @venue_category.update(venue_category_params)
        format.html { redirect_to edit_admin_venue_category_url(@venue_category), notice: 'Venue category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @venue_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @venue_category = VenueCategory.find(params[:id])
    @venue_category.delete

    respond_to do |format|
      format.html { redirect_to admin_venue_categories_path }
      format.json { head :no_content }
    end
  end


  private
  def venue_category_params
    params.require(:venue_category).permit(:venue_type)
  end

end
