class ChangeDateFormatForStartsAtInEvents < ActiveRecord::Migration

  def change
    change_column :events, :starts_at, :datetime
  end

end
