class PicturesController < ApplicationController
  before_filter :load_imageable,only: [:create]

  def create
    @picture = @imageable.pictures.create(picture_params)
  end

  def destroy
    #TODO make it asynchronously
    @picture = Picture.find(params[:id])
    @event = @picture.imageable
    @picture.destroy
    redirect_to @event, notice: "Picture was successfully destroyed."
  end

  private

  def load_imageable
    resource, id = params[:resource],params[:resource_id]
    @imageable = resource.singularize.classify.constantize.find(id)
  end

  def picture_params
    params.require(:picture).permit(:image)
  end
end
