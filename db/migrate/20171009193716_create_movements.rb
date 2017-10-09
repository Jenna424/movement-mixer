class CreateMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :movements do |t|
      t.string :instructions
      t.string :target_area
      t.integer :reps
      t.string :modification
      t.string :challenge
    end
  end
end
