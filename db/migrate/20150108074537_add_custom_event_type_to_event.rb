class AddCustomEventTypeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :custom_event_type, :string
  end
end
