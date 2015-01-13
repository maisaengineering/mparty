class OrdersController < ApplicationController
  before_filter :auth_user

  def index
    @orders = spree_current_user.completed_orders
  end

end
