class AddIsPrivateColumnToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :is_private, :boolean, :default => true
  end
end
