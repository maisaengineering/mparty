class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :content

      t.timestamps
    end
  end
end
