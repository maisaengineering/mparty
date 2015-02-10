class InvRequest < ActiveRecord::Base
  belongs_to :event
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"

  after_create :send_notification


  private
  def send_notification
    Notifier.ask_host_to_invite(self.user,self.event).deliver
  end
end
