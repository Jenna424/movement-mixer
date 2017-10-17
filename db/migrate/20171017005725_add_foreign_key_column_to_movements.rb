class AddForeignKeyColumnToMovements < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :user_id, :integer
  end
end
