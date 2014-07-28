# Override for providing scope for facebook authentication

OmniAuth::Strategies::Facebook.class_eval do
  def request_phase
    # Set your permissions here....
    options[:scope] ||= "email,user_friends"
    #options[:display] = mobile_request? ? 'touch' : 'page'
    super
  end
end