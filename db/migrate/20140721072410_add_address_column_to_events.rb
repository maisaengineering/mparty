class AddAddressColumnToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :shipping_address_id, :integer
  end
end
