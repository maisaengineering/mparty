class InvitationNotifier < ActionMailer::Base
  default from: "MParty <#{ENV['SENDER']}>"
  def notify_accepted_inv(invite)
    @invite = invite
    @event = invite.event
    if invite.invited_by.present?
      @invited_by = invite.invited_by
    else
      @invited_by = Spree::User.find(invite.event.user_id)
    end
    @accepted_by = invite.user ? "#{invite.user.full_name}" : invite.recipient_email
    mail(to: @invited_by.email, subject: "#{@event.name} is Accepted")
  end
end
