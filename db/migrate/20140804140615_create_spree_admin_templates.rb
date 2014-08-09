class CreateSpreeAdminTemplates < ActiveRecord::Migration
  def change
    create_table :spree_admin_templates do |t|
      t.string :name

      t.timestamps
    end
  end
end
