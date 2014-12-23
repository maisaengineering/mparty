class Review < ActiveRecord::Base
  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewed_by, foreign_key: "user_id", class_name: "Spree::User" # event created user
  validates :description, presence: true 
end
