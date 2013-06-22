class AddColumns < ActiveRecord::Migration
  def change
    add_column :activities, :times_visited, :integer, :default => 0
    add_column :activities, :dup_status, :string, :default => "No"
    add_column :categories, :video_url, :string
    add_column :categories, :image_url, :string
    add_column :categories, :description, :text
  end
end
