class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.string :title
    	t.string :description
    	t.string :location
      t.date :date
      t.integer :creator_id
      t.timestamps
    end

    add_index  :events, :creator_id

  end
end
