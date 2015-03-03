class InvitationNotifier < ActionMailer::Base
  default from: "MParty <#{ENV['SENDER']}>"
  def notify_accepted_inv(invite_id)
    @invite = Invite.find(invite_id)
    @event = @invite.event
    if @invite.invited_by.present?
      @invited_by = @invite.invited_by
    else
      @invited_by = Spree::User.find(@invite.event.user_id)
    end
    @accepted_by = @invite.user ? "#{@invite.user.full_name}" : @invite.recipient_email
    mail(to: @invited_by.email, subject: "#{@event.name} is Accepted")
  end

  def email_after_purchase_to_inviter(event_id,order_id)
    @event = Event.includes(:wishlist).find(event_id)
    @inviter = Spree::User.find(@event.user_id)
    @order= Spree::Order.find(order_id)
    @url="#{spree.root_url}#{event_path(:id => @event.id)}"
    if @order.user_id.nil?
      @invitee = @order.email
    else
      @invitee = Spree::User.find(@order.user_id).full_name
    end
    mail(to: @inviter.email, subject: "Products Purchased")
  end

  def email_after_purchase_to_invitees(event_id,order_id,invite_id)
    @event = Event.includes(:wishlist).find(event_id)
    @order= Spree::Order.find(order_id)
    @inviter = Spree::User.find(@event.user_id)
    invite = Invite.find(invite_id)

    if invite.user_id.present?
      @invitee = Spree::User.find_by_email(invite.user_id)
      @invitee_name = @invitee.full_name
    else
      @invitee_name = invitee.recipient_email
    end

    if @order.user_id.nil?
      @purchaser_name = @order.email
    else
      @purchaser_name = Spree::User.find(@order.user_id).full_name
    end
    mail(to: invite.recipient_email, subject: "Products Purchased")
  end

  def send_remainder_mail(event_id,invite_id)
    @event = Event.find(event_id)
    @invite = Invite.find(invite_id)
    @invite_email = @invite.recipient_email
    @token = @invite.token
    @template = @event.template
    @design = @template.designs.where(id: @event.design_id).first if @template
    @sender_name = @event.owner.full_name
    @url =  "#{spree.root_url}#{view_invitation_path(:invitation_code => @invite.token)}"
    mail(to: @invite_email, subject: "Remainder mail from #{@event.user.full_name} to join #{@event.name}", from: "<#{ENV['SENDER']}>")
  end

end
