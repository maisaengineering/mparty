class Notifier < ActionMailer::Base

  def invite_friend(inv, token)
    @token = token
    mail(to: inv, subject: "Invitation to join mparty", from: "<#{ENV['SENDER']}>", reply_to: inv)
  end

  def welcome_email(user)
    email = user.email
    mail(to: email, subject: "Welcome to MParty", from: "<#{ENV['SENDER']}>", reply_to: email)
  end
end