class Spree::Admin::EventCategoriesController < Spree::Admin::BaseController
  before_action :set_event_category, only: [:show, :edit, :update, :destroy]

  def index
    @event_categories = Spree::Admin::EventCategory.all
  end

  def show
  end

  def new
    @event_category = Spree::Admin::EventCategory.new
  end

  def edit
  end

  def create
    @event_category = Spree::Admin::EventCategory.new(event_category_params)
    respond_to do |format|
      if @event_category.save
        format.html { redirect_to @event_category, notice: 'Event category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @event_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event_category.update(event_category_params)
        format.html { redirect_to @event_category, notice: 'Event category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event_category.destroy
    respond_to do |format|
      format.html { redirect_to event_categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_category
      @event_category = Spree::Admin::EventCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_category_params
      # raise params.inspect
      params.require(:admin_event_category).permit(:name)
    end
end
