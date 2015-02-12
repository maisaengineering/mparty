module InvitesHelper

  def inv_respond_url(status,token,email)
    "#{ spree.root_url}invites/update_invitation?&status=#{status}&invitation_code=#{token}&email=#{email}"
  end

  def link_to_invited_users(icon=nil,status=nil,joined=nil)
     link_to_if  policy(@event).invite?, pluralize(@event.attendees(status), 'person'),
                  invited_users_list_path(@event.id,joined: joined),remote: true,
                  title: "click here to view #{status} users list",
                  class: "txt_bold icon-#{icon} invited_users_list"
  end
end
