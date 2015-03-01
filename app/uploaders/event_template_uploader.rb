# encoding: utf-8

class EventTemplateUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
   include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
   def store_dir
     dir = "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
     Rails.env.production? ? dir : "uploads/event_templates/#{dir}"
   end

   def fog_directory
     if Rails.env.production?
       ENV['IS_HEROKU'].eql?('yes') ? 'test_mparty_pictures786' : 'mparty_pictures786'
     end
   end



end
