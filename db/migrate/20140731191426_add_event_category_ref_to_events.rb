class AddEventCategoryRefToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :event_category, index: true
  end
end
