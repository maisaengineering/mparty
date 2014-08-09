class AddQuantityColumnToWishedProducts < ActiveRecord::Migration
  def change
  	add_column :spree_wished_products, :quantity, :integer, :default => 1
  end
end
