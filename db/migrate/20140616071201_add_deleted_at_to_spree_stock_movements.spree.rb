class AddDeletedAtToSpreeStockMovements < ActiveRecord::Migration
  def change
    add_column :spree_stock_movements, :deleted_at, :datetime
  end
end
