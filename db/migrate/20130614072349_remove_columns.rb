class RemoveColumns < ActiveRecord::Migration
  def change
    remove_column :activities, :link
    remove_column :activities, :guid
    change_column :activities, :extern_id, :string
  end
end
