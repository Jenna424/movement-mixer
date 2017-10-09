class Movement < ActiveRecord::Base
  has_many :movement_routines
  has_many :routines, through: :movement_routines
end
