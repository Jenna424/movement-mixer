class ChangeInstructionsColumnDatatypeToTextInMovementsTable < ActiveRecord::Migration[5.1]
  def change
    change_column :movements, :instructions, :text
  end
end
