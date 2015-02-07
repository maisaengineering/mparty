module InvitesHelper

  def inv_respond_url(status,token,email)
    "#{ spree.root_url}invites/update_invitation?&status=#{status}&invitation_code=#{token}&email=#{email}"
  end
end
