class CreateSpreeAdminDesigns < ActiveRecord::Migration
  def change
    create_table :spree_admin_designs do |t|
      t.string :content
      t.integer :template_id

      t.timestamps
    end
  end
end
