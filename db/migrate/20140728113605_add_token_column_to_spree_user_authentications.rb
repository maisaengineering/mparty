class AddTokenColumnToSpreeUserAuthentications < ActiveRecord::Migration
  def change
  	add_column :spree_user_authentications, :fb_token, :string
  end
end
