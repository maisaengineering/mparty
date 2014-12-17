class PicturesController < ApplicationController
  before_filter :auth_user
  before_filter :load_imageable,only: [:create]

  def create
    @event = @imageable
    @picture = @imageable.pictures.create(picture_params)
  end

  def destroy
    #TODO make it asynchronously
    @picture = Picture.find(params[:id])
    imageable =  @picture.imageable
    @picture.destroy
    # if imageable.is_a?(Venue)
    #   redirect_to add_photos_venue_url(imageable), notice: "Picture was successfully destroyed."
    # else
    #   redirect_to @event, notice: "Picture was successfully destroyed."
    # end


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
