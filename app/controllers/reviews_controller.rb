class ReviewsController < ApplicationController
  before_filter :auth_user
  before_filter :load_reviewable

  def index
    @reviews = @reviewable.reviews
  end

  def new
    @review = @reviewable.reviews.build
  end

  def create
    @review = @reviewable.reviews.build(review_params)
    if @review.save
      flash.now[:success] = "Your Review posted successfully."
    else
      flash.now[:error] = "Errors: #{@review.errors.full_messages.to_sentence}"  unless @review.save
    end

  end

  private

  def load_reviewable
    resource, id = params[:resource_type] ,params[:resource_id]
    @reviewable = resource.singularize.classify.constantize.find(id)
  end

  def review_params
    params.require(:review).permit(:user_id,:heading,:description,:rating)
  end

end
