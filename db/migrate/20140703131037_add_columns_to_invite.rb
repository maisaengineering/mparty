class AddColumnsToInvite < ActiveRecord::Migration
  def change
  	rename_column :invites, :attended_event_id, :event_id
  	rename_column :invites, :attendee_id, :user_id
  	
  	add_column :invites, :invited_user_id, :integer
  	add_column :invites, :joined, :boolean 
  end
end
