class MovementRoutine < ActiveRecord::Base
  belongs_to :routine
  belongs_to :movement
end
