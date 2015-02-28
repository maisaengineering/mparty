class EventPolicy < Struct.new(:user, :event)
  # Event must be created if only user exists
  def create?
    user ? true : false
  end

  def new?
    user ? true : false
  end

  # Only owner of the event can update
  def update?
    event.is_owner?(user)
  end

  # A public event can be shown to all
  # A private event permitted to only owner and and the users who are invited
  def show?
    return true if event.is_public?
    event.is_private? and user and (event.is_owner?(user) or event.user_invited?(user)) #or event.user_joined?(user))
  end

  # Public event : show wishlist for only joined users(attending)
  # Private event : show wishlist for invited/joined users
  def show_wishlist?
     if event.is_public?
      return true
    else
     user and (event.is_owner?(user) or  event.user_invited?(user) or  event.user_joined?(user))
    end  
  end

  # only owner can invite others
  def invite?
    event.is_owner?(user)
  end

  # A public event can be joined by any user
  # A private event can only be joined by the users who are invited to this event
  def allow_rsvp?
    if event.user_joined?(user)
      false
    elsif event.is_public? or event.is_owner?(user)
      true
    elsif event.is_private? and user and event.user_invited?(user)
      true
    else
      false
    end
  end

  def allow_checkout?
    return false if user.nil? or  event.is_owner?(user)  or event.wishlist.nil?
    event.user_invited?(user) or event.user_joined?(user)
  end

  def allow_checkout_from_invitation_mail?
    !event.is_owner?(user)  and !event.wishlist.nil? and event.future_event?
  end


  # only owner can edit/update the event
  def edit?
    user and event.owner?(user)
  end

  # only owner can delete the event
  def delete?
    user and event.is_owner?(user)
  end

  # only joined users are permitted for commenting
  def allow_commenting?
    return false unless user
    event.user_joined?(user) or  event.is_owner?(user) or event.user_invited?(user)
  end

  def add_ship_address?
    event and event.wishlist and event.is_owner?(user)
  end

  def join?
    return true if user.nil? and event.is_public?
    user and event.is_public? and !event.is_owner?(user) and !event.user_joined?(user)
  end

  def leave?
    event.is_public?  and user  and event.user_joined?(user)
  end

  def allow_inv_request?
    event.is_private? and  !event.is_owner?(user) and !event.inv_requested?(user)
  end

  def event_expiration?
    invite? and  (event.ends_at >= Time.now)
  end

  def post_event_on_fb?
    return false unless user
    event.user_joined?(user) or  event.is_owner?(user) or event.user_invited?(user)
  end
  # only owner can preview the event
  def preview?
    user and event.is_owner?(user)
  end

  def add_wishlist?
    user and event.is_owner?(user) and (event.wishlist.nil? or (event.wishlist  and event.wishlist.wished_products.count == 0))
  end

end
