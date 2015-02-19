class VenueSeatingType < ActiveRecord::Base
  belongs_to :venue
  	mount_uploader :seating_image, VenueSeatingTypeUploader
  
end
