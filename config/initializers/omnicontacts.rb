require "omnicontacts"
Rails.application.middleware.use OmniContacts::Builder do
	importer :gmail, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {:redirect_path => "/contacts/gmail/contact_callback"}
end
OmniAuth.config.on_failure = Proc.new do |env|
	env['devise.mapping'] = Devise.mappings[:spree_user]
	controller_name  = ActiveSupport::Inflector.camelize(env['devise.mapping'].controllers[:omniauth_callbacks])
	controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
	controller_klass.action(:failure).call(env)
end