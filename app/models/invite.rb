class Invite < ActiveRecord::Base
  belongs_to :event
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"
  belongs_to :invited_by, foreign_key: "invited_user_id", class_name: "Spree::User"
end
