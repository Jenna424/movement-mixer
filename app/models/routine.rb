class Routine < ActiveRecord::Base
  belongs_to :user # a routine instance belongs to a single user instance
  has_many :movement_routines
  has_many :movements, through: :movement_routines
end
