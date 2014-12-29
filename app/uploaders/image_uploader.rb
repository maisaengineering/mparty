# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
   include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    dir = "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    Rails.env.production? ? dir : "uploads/#{dir}"
  end

   def fog_directory
     if Rails.env.production?
       ENV['IS_HEROKU'].eql?('yes') ? 'test_mparty_pictures786' : 'mparty_pictures786'
     end
   end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
   version :thumb  do
     process :resize_to_fill=> [90, 90]
   end

   version :slide_show  do
     process :resize_to_fill=> [190, 190],if: :event?
     process :resize_to_fill=> [195, 195],if: :venue?
   end

   version :preview  do
     process :resize_to_fill=> [262, 262],if: :event?
     process :resize_to_fill=> [360, 270],if: :venue?
   end

   protected

   def event?(new_file)
     self.model.imageable_type.eql?('Event')
   end

   def venue?(new_file) 
     self.model.imageable_type.eql?('Venue')
   end



  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end


end
