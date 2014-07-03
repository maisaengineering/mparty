class Notifier < ActionMailer::Base

  def invite_friend(inv, token)
    @token = token
    mail(to: inv, subject: "Invitation to join mparty", from: "<#{ENV['SENDER']}>", reply_to: inv)
  end
end