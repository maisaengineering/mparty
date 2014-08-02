class Spree::Admin::EventCategory < ActiveRecord::Base
  self.table_name = "event_categories"
  has_many :events
  has_many :templates
end
