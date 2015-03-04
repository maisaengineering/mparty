class Notifier < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  default from: "MParty <#{ENV['SENDER']}>"

  def invite_friend(email, inv_id,event_id)
   # from = invite.invited_by.email # for socail login users email is not mandatory
    @event = Event.find(event_id)
    invite = Invite.find(inv_id)
    @invite_email = invite.recipient_email
    @token = invite.token
    @template = @event.template
    @design = @template.designs.where(id: @event.design_id).first if @template
    @sender = @event.owner
    @url =  "#{view_invitation_url(:invitation_code => invite.token,email: email)}"
    mail(to: email, subject: "Invitation to join Mparty", from: "#{@sender.full_name} <#{ENV['SENDER']}>")
  end

  def welcome_email(email,full_name)
    @full_name = full_name
    mail(to: email, subject: "Welcome to MParty")
  end

  def ask_host_to_invite(user_id,event_id)
    @user = Spree::User.find(user_id)
    @event = Event.find(event_id)
    mail(to:  @event.user.email, subject: "asking Request to join #{@event.name}", from: "#{@user.full_name} <#{ENV['SENDER']}>")
  end

end