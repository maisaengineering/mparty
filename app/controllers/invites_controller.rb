class InvitesController < ApplicationController
  skip_before_filter :auth_user
  before_action :find_invitation
  before_filter :register_handlebars

  def show
    @comments = @event.comments.order('created_at DESC').limit(10)
  end

  def update_invitation
    @invitation.joined = params[:status]
    @invitation.user_id = spree_current_user.id if spree_current_user
    @invitation.save
    @wishlist = @event.wishlist
    #session[:event_id] = @event.id
    session[:invitation_id] = @invitation.id
    flash.now[:notice] = 'Thanks for your response'
  end

  private
  def find_invitation
    @invitation = Invite.find_by_token(params[:invitation_code])
    if @invitation
      @event = @invitation.event
      @event_template = Spree::Admin::Template.where(id: @event.template_id).first
      @event_design = @event_template.designs.where(id: @event.design_id).first if @event_template
    else
      render(text: 'We are sorry,Invitation not found with given token') and return
    end
  end
=begin
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
