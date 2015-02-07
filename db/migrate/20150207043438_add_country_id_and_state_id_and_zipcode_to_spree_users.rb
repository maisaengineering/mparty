class AddCountryIdAndStateIdAndZipcodeToSpreeUsers < ActiveRecord::Migration
  def change
    remove_column :spree_users, :country
    remove_column :spree_users, :state
    add_column :spree_users, :country_id,  :integer
    add_column :spree_users, :state_id,  :integer
    add_column :spree_users, :zipcode,  :integer
  end
end
