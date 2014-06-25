class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
    	t.integer :attendee_id
      t.integer :attended_event_id
      t.timestamps
    end

    add_index :invites, :attendee_id
    add_index :invites, :attended_event_id
    add_index :invites, [:attendee_id, :attended_event_id], unique: true
    
  end
end
