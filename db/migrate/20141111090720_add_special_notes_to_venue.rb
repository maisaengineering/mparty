class AddSpecialNotesToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :special_notes, :text
  end
end
