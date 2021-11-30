class AddTmsTitle < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :tms_title, :string
  end
end
