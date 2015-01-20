require "omnicontacts"
Rails.application.middleware.use OmniContacts::Builder do
	gmail_app_id = "272377628889-7cqksgqihtfu4hr6giouf1ru5lk4srkb.apps.googleusercontent.com"
	secret = "POJ84x3wvqmPTFhaa1S9iuBs"

	importer :gmail, gmail_app_id, secret, {:redirect_path => "/contacts/gmail/contact_callback"}	
end