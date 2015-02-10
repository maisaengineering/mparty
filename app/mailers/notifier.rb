class Notifier < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  default from: "MParty <#{ENV['SENDER']}>"

  def invite_friend(email, invite,event)
   # from = invite.invited_by.email # for socail login users email is not mandatory
    @event = event
    @invite_email = invite.recipient_email
    @token = invite.token
    @template = @event.template
    @design = @template.designs.where(id: @event.design_id).first if @template
    @sender = @event.owner
    @url =  "#{view_invitation_url(:invitation_code => invite.token,email: email)}"
    mail(to: email, subject: "Invitation to join Mparty", from: "#{@sender.full_name} <#{ENV['SENDER']}>")
  end

  def welcome_email(email)
    mail(to: email, subject: "Welcome to MParty")
  end

  def ask_host_to_invite(user,event)
    @user = user
    @event = event
    mail(to:  @event.user.email, subject: "asking Request to join #{@event.name}", from: "#{@user.full_name} <#{ENV['SENDER']}>")
  end

end