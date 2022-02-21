class AddExtraToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :extra, :boolean, default: false, null: false
  end
end
