class Notifier < ActionMailer::Base

  def invite_friend(inv)
    mail(to: inv, subject: "Invitation to join mparty", from: "<#{ENV['SENDER']}>", reply_to: inv)
  end
end