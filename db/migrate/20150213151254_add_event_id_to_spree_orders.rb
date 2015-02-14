class AddEventIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :event_id, :integer
    add_index :spree_orders, :event_id
  end
end
