class ChangeDateTypeForEventStartsAtAndEndsAt < ActiveRecord::Migration
  def change
    change_column :events, :starts_at,  :datetime
    change_column :events, :ends_at,  :datetime
  end
end
