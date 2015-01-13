class CreateVideoUrls < ActiveRecord::Migration
  def change
    create_table :video_urls do |t|
      t.text :url, null: false
      t.integer :video_url_id
      t.string :video_url_type

      t.timestamps
    end
	add_index :video_urls, :video_url_id    
  end
end
