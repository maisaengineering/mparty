class AddAvatarProcessingToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :avatar_processing, :boolean, null: false, default: false
  end
end
