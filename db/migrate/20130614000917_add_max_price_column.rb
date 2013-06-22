class AddMaxPriceColumn < ActiveRecord::Migration
  def change
    rename_column :activities, :price, :min_price
    add_column :activities, :max_price, :decimal, precision: 10, scale: 2
  end
end
