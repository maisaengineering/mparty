class RaterController < ApplicationController

  # def create
  #   if user_signed_in?
  #     obj = params[:klass].classify.constantize.find(params[:id])
  #     obj.rate params[:score].to_f, current_user, params[:dimension]
  #
  #     render :json => true
  #   else
  #     render :json => false
  #   end
  # end

  before_filter :auth_user
  def create
    @rateable =  params[:klass].classify.constantize.find(params[:id])
    @rateable.rate params[:score].to_f, current_spree_user, params[:dimension]
  end
end
