class Spree::Admin::Design < ActiveRecord::Base
  belongs_to :template, foreign_key: "template_id", class_name: "Spree::Admin::Template"
end
