class CreateWishlistOrders < ActiveRecord::Migration
  def change
    create_table :wishlist_orders do |t|
      t.integer :order_id, null: false
      t.integer :wishlist_id, null: false
      t.integer :wished_product_id, null: false
      t.integer :quantity_purchased,null: false,default: 0
      t.timestamps
    end
    add_index :wishlist_orders, :order_id
    add_index :wishlist_orders, :wishlist_id
    add_index :wishlist_orders, :wished_product_id
  end
end
