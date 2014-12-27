class InvitesController < ApplicationController
  #before_filter :validate_invite, :only => [:update_invitaion]
  skip_before_filter :auth_user
  before_filter :register_handlebars,only: [:show]

  def show
    @invitation = Invite.find_by_token(params[:invitation_code])
    if @invitation.present?
      @event = @invitation.event
      @comments = @event.comments.order('created_at DESC').limit(10)
      @event_template = Spree::Admin::Template.where(id: @event.template_id).first
      @event_design = @event_template.designs.where(id: @event.design_id).first if @event_template
    else
      flash[:error] = "We are sorry Invitation not found."
      render
    end
  end

  def update_invitation
    @invitaion = Invite.where(token: params[:token]).first
    @invitaion.update_attributes(joined: params[:status])
    @event = @invitaion.event
    @wishlist = @event.wishlist
    session[:event_id] = @event.id
    session[:invitaion_id] = @invitaion.id
    # if signed_in?
    #   if @invitaion.recipient_email == current_spree_user.email
    #     #redirect_to show_invitation_path(@event.id)
    #     #TODO change has_wishlist in invitation table if user adds wishlist later
    #     if @invitaion.has_wishlist == true
    #       @wishlist = @event.wishlist
    #       flash[:notice] = "Your friend likes following gifts."
    #       render "/events/_wishlist_cart"#, layout: 'application'
    #     else
    #       flash[:error] = "Invitation doesn't have wishlist"
    #       redirect_to event_path(id: @event.id)
    #     end
    #   else
    #     flash[:error] = "Access denied.You are not invited to this event"
    #    # redirect_to event_path(id: @event.id)
    #   end
    # else
    #   if @invitaion.has_wishlist == true
    #     @wishlist = @event.wishlist
    #     flash[:notice] = "Your friend likes following gifts."
    #     render "/events/_wishlist_cart"#, layout: 'application'
    #   else
    #     redirect_to event_path(id: @event.id)
    #   end
    # end
  end

=begin  private

  def validate_invite
    email = params[:invite_email]
    existing_user = Spree::User.find_by_email(email)
    if existing_user.present?
      true
    else
      redirect_to spree.signup_path(:invite_email => email)
    end  
  end
=end
end
