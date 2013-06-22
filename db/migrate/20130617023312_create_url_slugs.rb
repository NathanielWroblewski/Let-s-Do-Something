class CreateUrlSlugs < ActiveRecord::Migration
  def change
    add_column :activities, :url_slug, :string
    add_column :categories, :url_slug, :string
  end
end
