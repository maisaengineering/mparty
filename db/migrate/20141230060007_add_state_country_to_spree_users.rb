class AddStateCountryToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :city, :string
    add_column :spree_users, :state, :string
    add_column :spree_users, :country, :string
  end
end
