class Review < ActiveRecord::Base
  belongs_to :reviewable, polymorphic: true
  belongs_to :author, foreign_key: "user_id", class_name: "Spree::User" # event created user
  validates :user_id,presence: true
  validates :rating, presence: true, :numericality => {greater_than_or_equal_to: 0.5}
end
