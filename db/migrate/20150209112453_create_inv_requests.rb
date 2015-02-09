class CreateInvRequests < ActiveRecord::Migration
  def change
    create_table :inv_requests do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.timestamps
    end
  end
end
