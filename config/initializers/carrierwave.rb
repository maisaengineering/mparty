CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
        :provider                         => 'Google',
        :google_storage_access_key_id     => ENV['google_storage_access_key'],
        :google_storage_secret_access_key => ENV['google_storage_access_secret']
    }
    # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315360000'}  # optional, defaults to {}
  else
    config.storage = :file
  end

end
