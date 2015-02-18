# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  #Rails4.0 asking to create secret key using "rake secret" command
  config.secret_key = "c42c9ddf00d2ba744ccbce49dad17ed9913bb5de56ac33018a8fb474994d9d80e275ce91e78af745cd4532d58b9bb1e2b59a"

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html, should redirect to the sign in page when the user does not have
  # access, but formats like :xml or :json, should return 401.
  #
  # If you have any extra navigational formats, like :iphone or :mobile, you
  # should add them to the navigational formats lists.
  #

  # If http headers should be returned for AJAX requests. True by default.
  # config.http_authenticatable_on_xhr = true

  config.http_authenticatable = false
  config.http_authenticatable_on_xhr = false

  # The "*/*" below is required to match Internet Explorer requests.
  # config.navigational_formats = ["*/*", :html, :json, :mobile, :js, :xml]
  config.navigational_formats = ["*/*", :html,:js,:json]

end
