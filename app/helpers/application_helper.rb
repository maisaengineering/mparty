module ApplicationHelper

	def title
		controller = params[:controller]
		case controller
		when 'events'
  		"Events Management"
		when 'invites'
  		"Invitation Management"
		else
  		"Mparty Event Management"
		end	
	end

	def store_menu?
		if params[:controller] == 'events' || params[:controller] == 'invites'
			false
		end	
	end	

	def try_spree_current_user
		if current_spree_user.present?
			current_spree_user
		else
			false
		end	
  end
end
