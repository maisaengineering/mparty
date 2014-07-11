class AddEventIdColumnToWishlist < ActiveRecord::Migration
  def change
  	add_column :spree_wishlists, :event_id, :integer
  end
end
