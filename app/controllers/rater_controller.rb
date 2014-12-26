class RaterController < ApplicationController

  def create
    if current_spree_user.present?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_f, current_spree_user, params[:dimension]

      render :json => true
    else
      render :json => false
    end
  end
end
