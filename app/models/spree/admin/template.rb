class Spree::Admin::Template < ActiveRecord::Base
  has_many :events
  has_many :designs, class_name: "Spree::Admin::Design"
  has_many :pictures, as: :imageable
  accepts_nested_attributes_for :designs, :allow_destroy => true
end
