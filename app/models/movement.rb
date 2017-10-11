class Movement < ActiveRecord::Base
  has_many :movement_routines
  has_many :routines, through: :movement_routines

  validates :name, :presence => true
  validates :instructions, :presence => true
  validates :target_area, :presence => true
  validates :reps, :presence => true
  validates :modification, :presence => true
  validates :challenge, :presence => true
  # movement instance must have @name, @instructions, @target_area, @reps, @modification and @challenge attributes to be successfully saved to DB
end
