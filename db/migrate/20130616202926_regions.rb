class Regions < ActiveRecord::Migration
  def change
    create_table :regions do |column|
      column.string :name, :code
    end

    add_column :activities, :region_id, :integer
  end
end
