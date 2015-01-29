class VideoUrl < ActiveRecord::Base
	belongs_to :video_url, polymorphic: true
	validates :url, presence: true,allow_blank: false

  validate :update_image

  def update_image
    if (self.url.include?("youtube.com") || self.url.include?("vimeo.com"))
      begin
        doc = open(url) { |f| Hpricot(f) }
        c =doc.search('/html/head/meta[@property="og:image"]')
        image_url = c[0][:content] if c[0]
        self.image_url = image_url	          
      rescue Exception => e
       errors.add(:url, " not fount. #{e}") 
      end
    else
      errors.add(:supprted, "only for youtube and vimeo videos.") 
    end
  end
end
