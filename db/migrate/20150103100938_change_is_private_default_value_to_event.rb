class ChangeIsPrivateDefaultValueToEvent < ActiveRecord::Migration
  def change
    change_column :events, :is_private, :boolean, default: false
  end
end
