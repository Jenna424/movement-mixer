class Movement < ActiveRecord::Base
  has_many :movement_routines
  has_many :routines, through: :movement_routines

  validates :name, :presence => true
  validates :instructions, :presence => true
  validates :target_area, :presence => true
  validates :reps, :presence => true
  validates :modification, :presence => true
  validates :challenge, :presence => true
  
end
