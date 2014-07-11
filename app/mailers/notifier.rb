class Notifier < ActionMailer::Base

  def invite_friend(email, invite)
    from = invite.invited_by.email
    @sender_name = from.split('@')[0]
    @url =  "http://localhost:3000/#{view_invitation_path(:invitation_code => invite.token)}"
    mail(to: email, subject: "Invitation to join mparty", from: from)
  end

  def welcome_email(email)
    mail(to: email, subject: "Welcome to MParty", from: "<#{ENV['SENDER']}>", reply_to: email)
  end
end