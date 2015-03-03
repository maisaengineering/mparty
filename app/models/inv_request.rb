class InvRequest < ActiveRecord::Base
  belongs_to :event
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"

  after_create :send_notification


  private
  def send_notification
    Notifier.delay.ask_host_to_invite(user_id,event_id)
  end
end
