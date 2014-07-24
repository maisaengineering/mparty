class AddIsPurchasedColumnToSpreeWishedProducts < ActiveRecord::Migration
  def change
    add_column :spree_wished_products, :is_purchased, :boolean, default: false
  end
end
