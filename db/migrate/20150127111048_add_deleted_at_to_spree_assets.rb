class AddDeletedAtToSpreeAssets < ActiveRecord::Migration
  def change
  	add_column :spree_assets, :deleted_at, :datetime, default: nil
  end
end
