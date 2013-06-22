class Words < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :word, :wordable_type, :interpretation
      t.integer  :wordable_id, :counter
    end
  end
end
