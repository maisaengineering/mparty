class CreateTemplatesVenues < ActiveRecord::Migration
  def change
    create_table :templates_venues ,id: false do |t|
      t.integer :venue_id,null: false,index: true
      t.integer :template_id,null: false,index: true
    end
  end
end
