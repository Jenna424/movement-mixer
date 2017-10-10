class Movement < ActiveRecord::Base
  has_many :movement_routines
  has_many :routines, through: :movement_routines

  validates :name, :presence => true
  # a movement instance must have @name attribute value to be successfully saved to DB
  validates :reps, :presence => true
  # a movement instance must have @reps attribute value to be successfully saved to DB
end
