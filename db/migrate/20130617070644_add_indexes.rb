class AddIndexes < ActiveRecord::Migration
  def change
    add_index :activities, [:starts_at, :ends_at, :country_id]
    add_index :activities, [:ends_at, :country_id]
  end
end
