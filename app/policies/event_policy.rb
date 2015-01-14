class EventPolicy < Struct.new(:user, :event)
  # Event must be created if only user exists
  def create?
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
    if user and (event.is_owner?(user) or event.user_invited?(user))
      true
    else
      false
    end
  end

  # Public event : show wishlist for only joined users(attending)
  # Private event : show wishlist for invited/joined users
  def show_wishlist?
    return false if event.wishlist.nil?
    return true if event.is_owner?(user)
    if event.is_private?.
        event.user_invited?(user)
    else
      event.user_invited?(user) or event.user_joined?(user)
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

  def allow_checkout?(user)
    return false if event.wishlist.nil? or event.is_owner?(user)
    if event.is_private?
      event.user_invited?(user)
    else
      event.user_invited?(user) or event.user_joined?(user)
    end
  end


  # only owner can edit/update the event
  def edit?
    (user and event.owner?(user)) ? true : false
  end

  # only owner can delete the event
  def delete?
    (user and event.is_owner?(user)) ? true : false
  end

  # only joined users are permitted for commenting
  def allow_commenting?
    
  end


end
