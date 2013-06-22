class AddPriceColumn < ActiveRecord::Migration
   def change
    add_column :activities, :price, :decimal, precision: 10, scale: 2
  end
end
