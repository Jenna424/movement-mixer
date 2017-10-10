class AddNameColumnToMovementsTable < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :name, :string
  end
end
