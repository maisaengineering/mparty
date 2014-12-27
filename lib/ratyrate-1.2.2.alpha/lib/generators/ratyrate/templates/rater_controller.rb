class RaterController < ApplicationController

  def create
    if spree_current_user
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_f, spree_current_user, params[:dimension]

      render :json => true
    else
      render :json => false
    end
  end
end
