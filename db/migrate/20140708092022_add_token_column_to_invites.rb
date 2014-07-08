class AddTokenColumnToInvites < ActiveRecord::Migration
  def change
  	add_column :invites, :token, :string
  end
end
