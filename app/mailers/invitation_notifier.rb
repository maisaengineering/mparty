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
    if @invite.invited_user_id.blank?
      mail(to: @invited_by.email, subject: "#{@event.name} is Joined by #{@accepted_by}")
    else
      mail(to: @invited_by.email, subject: "#{@event.name} is Accepted by #{@accepted_by}")
    end
  end

  def email_after_purchase_to_inviter(event,order)
    @event = Event.includes(:wishlist).find(event.id)
    @inviter = Spree::User.find(@event.user_id)
    @order=order
    @url="#{spree.root_url}#{event_path(:id => @event.id)}"
    if order.user_id.nil?
      @invitee = order.email
    else
      @invitee = Spree::User.find(order.user_id).full_name
    end
    mail(to: @inviter.email, subject: "Products Purchased")
  end

  def email_after_purchase_to_invitees(event,order,invitee)
    @event = Event.includes(:wishlist).find(event.id)
    @order=order
    @inviter = Spree::User.find(@event.user_id)


    if invitee.user_id.present?
      @invitee = Spree::User.find_by_email(invitee.recipient_email)
      @invitee_name = @invitee.full_name
    else
      @invitee_name = invitee.recipient_email
    end

    if order.user_id.nil?
      @purchaser_name = order.email
    else
      @purchaser_name = Spree::User.find(order.user_id).full_name
    end
    mail(to: invitee.recipient_email, subject: "Products Purchased")
  end

  def send_remainder_mail(event,invite)
    @event = event
    @invite_email = invite.recipient_email
    @token = invite.token
    @template = @event.template
    @design = @template.designs.where(id: @event.design_id).first if @template
    @sender_name = @event.owner.full_name
    @url =  "#{spree.root_url}#{view_invitation_path(:invitation_code => invite.token)}"
    mail(to: @invite_email, subject: "Remainder mail from #{@event.user.full_name} to join #{@event.name}", from: "<#{ENV['SENDER']}>")
  end

end
