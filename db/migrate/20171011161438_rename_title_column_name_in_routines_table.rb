class RenameTitleColumnNameInRoutinesTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :routines, :title, :name
  end
end
