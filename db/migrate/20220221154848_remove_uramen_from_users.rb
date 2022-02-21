class RemoveUramenFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :uramen, :boolean
  end
end