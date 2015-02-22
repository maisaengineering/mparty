class AddRatingToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :rating, :float, default: 0.0
  end
end
