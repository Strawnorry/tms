class RemoveExtraToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :extra, :boolean
  end
end
