class CreateMovementRoutines < ActiveRecord::Migration[5.1]
  def change
    create_table :movement_routines do |t|
      t.integer :routine_id
      t.integer :movement_id
    end
  end
end
