Spree::Admin::OverviewController.class_eval do
  prepend_before_filter :redirect_distributors, :only => :index

  private
  def redirect_distributors
    if current_user && current_user.has_spree_role?('csr')
      redirect_to admin_venues_url
    end
  end
end