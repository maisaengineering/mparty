class AddQuantityPurchasedColumnToWishedProducts < ActiveRecord::Migration
  def change
  	add_column :spree_wished_products, :quantity_purchased, :integer, :default => 0
  end
end
