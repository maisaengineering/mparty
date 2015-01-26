class AddVideoimageToVideoUrls < ActiveRecord::Migration
  def change
    add_column :video_urls, :image_url, :string
  end
end
