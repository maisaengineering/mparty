class Spree::Admin::Design < ActiveRecord::Base
  self.table_name = "spree_admin_designs"
  belongs_to :template, foreign_key: "template_id", class_name: "Spree::Admin::Template"
end
