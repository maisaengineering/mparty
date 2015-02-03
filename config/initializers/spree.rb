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
	config.logo = 'logo.png'
	config.admin_interface_logo = 'logo.png'
  config.layout='spree_application'
  config.allow_ssl_in_production = false

  config.override_actionmailer_config = false
  config.mails_from = "no-reply@mparty.io"

  if Rails.env.production?

     attachment_config = {
         :storage => :fog,
         :fog_credentials => {provider: 'google',
                       google_storage_access_key_id: ENV['google_storage_access_key'],
                       google_storage_secret_access_key: ENV['google_storage_access_secret'],
         :fog_directory => 'test_mparty_products', 
         :bucket => 'test_mparty_products',
         styles: {
                  mini:     "48x48>",
                  small:    "100x100>",
                  product:  "240x240>",
                  large:    "600x600>"
         },

         path:           "/spree/:class/:id/:style/:basename.:extension",
         default_url:    "/spree/:class/:id/:style/:basename.:extension",
         default_style:  "product"
     }

     attachment_config.each do |key, value|
         Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
     end

  end 
end
Spree::Config[:layout]='application'
Spree::Ability.register_ability(CsrAbility)

Spree.user_class = "Spree::LegacyUser"
Spree::SocialConfig[:path_prefix] = ''

Spree::PermittedAttributes.user_attributes << :first_name
Spree::PermittedAttributes.user_attributes << :last_name
Spree::PermittedAttributes.user_attributes << :phone
Spree::PermittedAttributes.user_attributes << :address

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

