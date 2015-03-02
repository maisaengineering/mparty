class Picture < ActiveRecord::Base
	 belongs_to :imageable, polymorphic: true
	 mount_uploader :image, ImageUploader
   process_in_background :image
   before_create :default_name

   def default_name
     self.name ||= File.basename(image.filename, '.*').titleize if image
   end


end
