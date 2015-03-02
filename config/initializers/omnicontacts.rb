require "omnicontacts"
Rails.application.middleware.use OmniContacts::Builder do
	gmail_app_id = "940864621586-andmc7cafjfs56hc06mdrmqlort53osi@developer.gserviceaccount.com"
	secret = "BX4_HKDsDvyt7C3TJuuLbQ6D"

	importer :gmail, gmail_app_id, secret, {:redirect_path => "/contacts/gmail/contact_callback"}	
end
OmniAuth.config.on_failure = Proc.new do |env|
	env['devise.mapping'] = Devise.mappings[:spree_user]
	controller_name  = ActiveSupport::Inflector.camelize(env['devise.mapping'].controllers[:omniauth_callbacks])
	controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
	controller_klass.action(:failure).call(env)
end