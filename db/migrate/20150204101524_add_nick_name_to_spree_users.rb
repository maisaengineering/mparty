class AddNickNameToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :nickname, :string
  end
end
