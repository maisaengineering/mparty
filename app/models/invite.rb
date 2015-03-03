class Invite < ActiveRecord::Base
  belongs_to :event
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"
  belongs_to :invited_by, foreign_key: "invited_user_id", class_name: "Spree::User"
  # Can't send duplicate event invitation to the  same user

  validates_uniqueness_of :user_id, scope: :event_id,allow_blank: true

  before_create :generate_token

  after_update :send_notification_to_owner

  # pending => 0
  # accepted => 1
  # maybe => 3
  # rejected => 2





  private
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

  def send_notification_to_owner
    InvitationNotifier.delay.notify_accepted_inv(self.id)  if (self.joined_changed? && self.joined == 1)
  end
end
