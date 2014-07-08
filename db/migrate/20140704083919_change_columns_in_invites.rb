class ChangeColumnsInInvites < ActiveRecord::Migration
  def change
  	change_column :invites, :joined, :integer, :default => 0, :null => false
  	add_column :invites, :recipient_email, :string
  end
end
