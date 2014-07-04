class EventsController < ApplicationController

	def index
		@events = current_spree_user.events 
	end
	
	def new
		@event = current_spree_user.events.build
	end

	def create
		@event = current_spree_user.events.build(event_params)
		if @event.save
			redirect_to event_path(@event)
		else
			render 'new'
		end

	end

	def show
		@event = Event.find(params[:id])
	end

	def title
	 title = "Event Creation"
  end

  def send_invitation
    emails = params[:friend_emails]
    e = emails.split(',')
    e.each do |email|
      token = SecureRandom.urlsafe_base64
      Notifier.invite_friend(email, token).deliver
    end
    redirect_to '/index'
  end

	private
		def event_params
			params.require(:event).permit(:name, :location, :description, :starts_at, :ends_at)
		end
end
