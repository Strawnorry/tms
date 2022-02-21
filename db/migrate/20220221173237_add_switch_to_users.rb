class AddSwitchToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :switch, :integer, default: 0
  end
end