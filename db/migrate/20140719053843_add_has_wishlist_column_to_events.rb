class AddHasWishlistColumnToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :has_wishlist, :boolean, :default => false
  end
end
