class AddAvatarToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :avatar, :string
  end
end
