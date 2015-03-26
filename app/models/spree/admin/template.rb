class Spree::Admin::Template < ActiveRecord::Base
  self.table_name = "spree_admin_templates"
  has_many :events
  has_many :designs, class_name: "Spree::Admin::Design"
  has_many :pictures, as: :imageable
  has_and_belongs_to_many :venues, :join_table => 'templates_venues'
  accepts_nested_attributes_for :designs, :allow_destroy => true

end
