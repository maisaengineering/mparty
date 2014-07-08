class Invite < ActiveRecord::Base
  belongs_to :event
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"
  belongs_to :invited_by, foreign_key: "invited_user_id", class_name: "Spree::User"

  before_create :generate_token

  private

  	def generate_token
  		self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
		end
end
