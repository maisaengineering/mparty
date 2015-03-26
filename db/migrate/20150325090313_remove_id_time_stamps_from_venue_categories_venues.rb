class RemoveIdTimeStampsFromVenueCategoriesVenues < ActiveRecord::Migration
  def change
    remove_column(:venue_categories_venues ,:id) if column_exists?(:venue_categories_venues, :id)
    remove_column(:venue_categories_venues ,:created_at) if column_exists?(:venue_categories_venues, :created_at)
    remove_column(:venue_categories_venues ,:updated_at) if column_exists?(:venue_categories_venues, :updated_at)
  end
end
