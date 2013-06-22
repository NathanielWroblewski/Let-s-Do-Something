class Countries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, :code
    end

    add_column :activities, :country_id, :integer
  end
end
