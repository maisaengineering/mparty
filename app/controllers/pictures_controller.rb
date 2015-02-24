class PicturesController < ApplicationController
  before_filter :auth_user
  before_filter :load_imageable,only: [:create]

  def create
    @picture = Picture.new({imageable_type: @imageable.class.to_s,imageable_id: @imageable.id}.merge!(picture_params))
    @picture.save
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

  def edit_photos
    @event=Event.find(params[:id])
  end

  def remove_all
    begin
      Picture.where(id: params[:ids].split(',')).destroy_all
    rescue
    end
    render nothing: true
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
