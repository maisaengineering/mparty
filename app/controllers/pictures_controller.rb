class PicturesController < ApplicationController
  before_filter :load_imageable

  def index
    @pictures = @imageable.comments
  end

  def new
    @picture = @imageable.pictures.new
  end

  def create
    @picture = @imageable.pictures.new(picture_params)
    if @picture.save
      redirect_to @imageable
    else
      render :new
    end
  end

  private

  def load_imageable
    resource, id = request.path.split('/')[1, 2]
    @imageable = resource.singularize.classify.constantize.find(id)
  end

  # alternative option:
  # def load_commentable
  #   klass = [Article, Photo, Event].detect { |c| params["#{c.name.underscore}_id"] }
  #   @commentable = klass.find(params["#{klass.name.underscore}_id"])
  # end

  def picture_params
    params.require(:picture).permit(:image)
  end
end
