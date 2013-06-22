class RemoveRegionAndCountryColumns < ActiveRecord::Migration
  def change
    remove_column :activities, :region
    remove_column :activities, :country
  end
end
