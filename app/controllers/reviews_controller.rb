class ReviewsController < ApplicationController
  before_filter :load_commentable

  def index
    @reviews = @commentable.reviews
  end

  def new
    @review = @commentable.reviews.new
  end

  def create
    @review = @commentable.reviews.build(user_id: current_spree_user.id,description: params[:description],heading: current_spree_user.first_name)
  end

  private

  def load_commentable
    resource, id = params[:resource] ,params[:venue_id]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end
