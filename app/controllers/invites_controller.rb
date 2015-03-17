class InvitesController < ApplicationController
  skip_before_filter :auth_user
  before_action :find_invitation
  before_filter :register_handlebars

  def show
    @comments = @event.comments.order('created_at DESC').limit(10)
    @wishlist = @event.wishlist
  end

  def update_invitation
    @invitation.joined = params[:status]
    if spree_current_user and spree_current_user.email.eql?(@invitation.recipient_email)
      @invitation.user_id = spree_current_user.id
    end
    @invitation.save
    @wishlist = @event.wishlist
    session[:invitee_email] = params[:email].strip if  params[:email].present? and @wishlist
  end

  private
  def find_invitation
    @invitation = Invite.find_by_token(params[:invitation_code])
    if @invitation
      @event = @invitation.event
      unless @event.fb_image.url.present?
        @event_template = Spree::Admin::Template.where(id: @event.template_id).first
        @event_design = @event_template.designs.where(id: @event.design_id).first if @event_template
      end
    else
      render(text: 'We are sorry,Invitation not found with given token') and return
    end
  end

end
