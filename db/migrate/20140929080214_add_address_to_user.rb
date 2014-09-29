class AddAddressToUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :address, :string, default: nil
  end
end
