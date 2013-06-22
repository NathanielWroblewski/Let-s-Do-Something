class Activities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :category_id 
      t.integer :user_id 
      t.integer :extern_id
      t.string :title
      t.text :description
      t.string :phone
      t.text :guid
      t.string :link
      t.string :creator
      t.float :lat
      t.float :long
      t.datetime :starts_at
      t.datetime :ends_at
      t.float :duration
      t.string :venue_name
      t.string :street
      t.string :city
      t.string :region 
      t.integer :zip
      t.string :country
      t.string :recurrence
      t.string :url
      t.string :image_url
      t.timestamps
    end
  end
end
