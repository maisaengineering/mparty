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

  def bootstrap_class_for(flash_type)
    # case flash_type
    #   when "success"
    #     "alert-success"   # Green
    #   when "error"
    #     "alert-danger"    # Red
    #   when "alert"
    #     "alert-warning"   # Yellow
    #   when "notice"
    #     "alert-info"      # Blue
    #   else
    #     flash_type.to_s
    # end


    {
        success: 'alert-success',# Green
        error: 'alert-danger',# Red
        alert: 'alert-warning',# Yellow
        notice: 'alert-info' # Blue
    }[flash_type.to_sym] || flash_type.to_s

  end


end
