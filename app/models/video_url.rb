class VideoUrl < ActiveRecord::Base
	belongs_to :video_url, polymorphic: true
	validates :url, presence: true
end
