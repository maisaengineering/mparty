class Spree::Admin::TemplatesController < Spree::Admin::BaseController
  before_action :set_spree_admin_template, only: [:show, :edit, :update, :destroy]

  # GET /spree/admin/templates
  # GET /spree/admin/templates.json
  def index
    @spree_admin_templates = Spree::Admin::Template.all
  end

  # GET /spree/admin/templates/1
  # GET /spree/admin/templates/1.json
  def show
  end

  # GET /spree/admin/templates/new
  def new
    @spree_admin_template = Spree::Admin::Template.new
    @spree_admin_template.designs.build
  end

  # GET /spree/admin/templates/1/edit
  def edit
  end

  # POST /spree/admin/templates
  # POST /spree/admin/templates.json
  def create
    @spree_admin_template = Spree::Admin::Template.new(spree_admin_template_params)

    respond_to do |format|
      if @spree_admin_template.save
        format.html { redirect_to @spree_admin_template, notice: 'Template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @spree_admin_template }
      else
        format.html { render action: 'new' }
        format.json { render json: @spree_admin_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spree/admin/templates/1
  # PATCH/PUT /spree/admin/templates/1.json
  def update
    respond_to do |format|
      if @spree_admin_template.update(spree_admin_template_params)
        format.html { redirect_to @spree_admin_template, notice: 'Template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @spree_admin_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spree/admin/templates/1
  # DELETE /spree/admin/templates/1.json
  def destroy
    @spree_admin_template.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spree_admin_template
      @spree_admin_template = Spree::Admin::Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spree_admin_template_params
      params.require(:admin_template).permit(:name, designs_attributes: [:content, :_destroy, :id])
    end
end
