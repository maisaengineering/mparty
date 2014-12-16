class AddCityStateCountryZipToEvents < ActiveRecord::Migration
  def change
    add_column :events, :city, :string
    add_column :events, :state, :string
    add_column :events, :country, :string
    add_column :events, :zip, :string
  end
end
