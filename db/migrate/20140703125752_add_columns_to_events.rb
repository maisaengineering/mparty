class AddColumnsToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :ends_at, :datetime
  	add_column :events, :attendees_count, :integer, :default => 0
  	
  	rename_column :events, :title, :name
  	rename_column :events, :date, :starts_at
  	rename_column :events, :creator_id, :user_id
  end
end
