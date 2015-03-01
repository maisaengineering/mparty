class AddFbImageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :fb_image, :string
  end
end
