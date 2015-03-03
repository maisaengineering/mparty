class AddDesignCreatedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :design_created, :boolean, null: false, default: false
  end
end
