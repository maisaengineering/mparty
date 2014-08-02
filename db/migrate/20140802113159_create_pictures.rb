class CreatePictures < ActiveRecord::Migration
	def change
		create_table :pictures do |t|
			t.string  :name
			t.string :image
			t.references :imageable, polymorphic: true
			t.timestamps
		end
	end
end
