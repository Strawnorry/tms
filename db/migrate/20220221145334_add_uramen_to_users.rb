class AddUramenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :uramen, :boolean, default: false, null: false
  end
end
