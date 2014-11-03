class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name,limit: 100,null: false
      t.text :description
      t.string :venue_type # Banquet,conference etc
      t.integer :room_dimensions # 1400 sq feet etc
      t.integer :capacity ,default: 0# 200 members etc
      t.float :price_min,default: 0
      t.float :price_max,default: 0
      t.string :location #geo
      # Address
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.string :zip


      t.text :facilities #Air Conditioned ,Alcohol , Dedicated Parking,Wi-Fi etc

      # Contact details
      t.string :contact_name
      t.string :contact_mobile
      t.string :contact_land



      t.timestamps
    end
    add_index  :venues, :name
    add_index  :venues, :venue_type

  end
end
