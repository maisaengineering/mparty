class ChangeContentTypeInDesigns < ActiveRecord::Migration
  def change
    change_column :spree_admin_designs, :content, :text
  end
end
