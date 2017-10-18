class AddSetsColumnToMovementsTable < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :sets, :integer
  end
end
