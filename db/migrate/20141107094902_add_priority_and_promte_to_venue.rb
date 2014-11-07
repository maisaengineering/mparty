class AddPriorityAndPromteToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :promote, :boolean, default: false
    add_column :venues, :priority, :integer ,default: 0
  end
end
