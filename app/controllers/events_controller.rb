class EventsController < ApplicationController
	
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

	def index
		@events_upcoming = Event.upcoming 
		@events_past = Event.past 
	end

	def title
	 title = "Event Creation"
  end

  def send_invitation
    emails = params[:friend_emails]
    e = emails.split(',')
    e.each do |email|
      Notifier.invite_friend(email).deliver
    end
  end

	private
		def event_params
			params.require(:event).permit(:title, :location, :description, :date)
		end
end
