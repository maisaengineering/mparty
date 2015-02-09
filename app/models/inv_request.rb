class InvRequest < ActiveRecord::Base
  belongs_to :event
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"
end
