class RsvpsController < ApplicationController
  before_filter :auth_user, except: [:create, :destroy]

  def create
    @event = Event.find(params[:event_id])
    user = Spree::User.where(email: params[:invite_email]).first
    if user.nil?
      user = Spree::User.create(email: params[:invite_email], password: "123456", password_confirmation: "123456")
    end
    rsvp = @event.rsvps.build(user: user)

    if rsvp.save
      redirect_to @event, notice: 'You have successfully RSVPed.'
    else
      flash[:error] = rsvp.errors.full_messages.to_sentence
      redirect_to @event
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    current_user.cancel_rsvp(@event)
    redirect_to @event, notice: 'You have successfully canceled your RSVP.'
  end

end
