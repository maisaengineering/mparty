class AddProfileColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :spree_users, :first_name, :string, :default => nil
  	add_column :spree_users, :last_name, :string, :default => nil
  	add_column :spree_users, :phone, :string, :default => nil
  end
end
