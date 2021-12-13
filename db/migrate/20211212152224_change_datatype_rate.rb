class ChangeDatatypeRate < ActiveRecord::Migration[6.1]
  def change
    change_column :histories, :rate, 'integer USING rate::integer'
  end
end
