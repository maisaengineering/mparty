class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :heading
      t.string :description
      t.integer :user_id
      t.belongs_to :reviewable, polymorphic: true
      t.timestamps
    end
    add_index :reviews, [:reviewable_id, :reviewable_type]
  end
end
