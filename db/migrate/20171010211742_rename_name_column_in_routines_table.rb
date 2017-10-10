class RenameNameColumnInRoutinesTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :routines, :name, :title
  end
end
