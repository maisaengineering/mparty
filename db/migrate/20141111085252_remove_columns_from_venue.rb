class RemoveColumnsFromVenue < ActiveRecord::Migration
  def change
    remove_column :venues, :location
    remove_column :venues, :contact_name
    remove_column :venues, :contact_mobile
    remove_column :venues, :contact_land
  end
end
