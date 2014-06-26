# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
	# Example:
	# Uncomment to override the default site name.
	config.site_name = "Mparty Event Management"
	config.logo = 'maisa_logo.png'
	config.admin_interface_logo = 'maisa_logo.png'

end

Spree.user_class = "Spree::LegacyUser"
Spree::SocialConfig[:path_prefix] = ''

#spree email to friend mailer override
Spree::ToFriendMailer.class_eval do
	def mail_to_friend(object, mail)
    @object = object
    @mail = mail
    opts = {}
    if mail.hide_recipients
      opts[:to]  = mail.recipient_email
      opts[:bcc] = mail.recipients
    else
      #opts[:to] = [mail.recipient_email, mail.recipients.to_s.split(',')].flatten
      opts[:to] = mail.recipients.join(", ")
    end
    default_url_options[:host] = mail.host
    opts[:subject] =  mail.subject
    opts[:reply_to] = mail.sender_email

    mail(opts)
  end
end	