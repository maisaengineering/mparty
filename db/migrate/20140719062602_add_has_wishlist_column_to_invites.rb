class AddHasWishlistColumnToInvites < ActiveRecord::Migration
  def change
  	add_column :invites, :has_wishlist, :boolean, :default => false
  end
end
