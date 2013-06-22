class AddArrayColumns < ActiveRecord::Migration
  def change
    add_column :activities, :title_words, :text, :array => true
    add_column :activities, :description_words, :text, :array => true
  end
end
