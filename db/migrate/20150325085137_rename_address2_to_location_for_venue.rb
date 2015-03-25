class RenameAddress2ToLocationForVenue < ActiveRecord::Migration
  def change
    change_table :venues do |t|
      t.rename :address1, :address
      t.rename :address2, :location
    end
  end
end
