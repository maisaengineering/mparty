class AddTemplateIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :template_id, :integer
    add_column :events, :design_id, :integer
  end
end
