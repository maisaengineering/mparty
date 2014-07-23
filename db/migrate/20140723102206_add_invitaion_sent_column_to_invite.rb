class AddInvitaionSentColumnToInvite < ActiveRecord::Migration
  def change
  	add_column :invites, :mail_sent, :boolean, :default => false
  end
end
