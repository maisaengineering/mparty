class Notifier < ActionMailer::Base
  include ApplicationHelper
  helper :application

  def invite_friend(email, invite,event,handlebars)
   # from = invite.invited_by.email # for socail login users email is not mandatory
    @event = event
    @invite_email = invite.recipient_email
    @token = invite.token
    @template = @event.template
    @handlebars = handlebars
    @design = @template.designs.where(id: @event.design_id).first if @template

    @sender_name = @event.owner.full_name
    @url =  "#{spree.root_url}#{view_invitation_path(:invitation_code => invite.token)}"
    mail(to: email, subject: "Invitation to join mparty", from: "<#{ENV['SENDER']}>")
  end

  def welcome_email(email)
    mail(to: email, subject: "Welcome to MParty", from: "<#{ENV['SENDER']}>", reply_to: email)
  end

end