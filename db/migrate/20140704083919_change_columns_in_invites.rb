class ChangeColumnsInInvites < ActiveRecord::Migration
  def change
  	add_column :invites, :recipient_email, :string
  end
end
