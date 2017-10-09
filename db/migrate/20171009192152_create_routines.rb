class CreateRoutines < ActiveRecord::Migration[5.1]
  def change
    create_table :routines do |t|
      t.string :name
      t.string :training_type
      t.string :duration
      t.string :difficulty_level
      t.string :equipment
    end
  end
end
