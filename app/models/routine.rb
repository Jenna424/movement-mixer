class Routine < ActiveRecord::Base
  include Sluggable::InstanceMethods
  extend Sluggable::ClassMethods
  
  belongs_to :user # a routine instance belongs to a single user instance
  has_many :movement_routines
  has_many :movements, through: :movement_routines
# routine instance must have @name, @training_type, @duration, @difficulty_level and @equipment attributes set to be successfully saved to DB
  validates :name, :presence => true
  validates :training_type, :presence => true
  validates :duration, :presence => true
  validates :difficulty_level, :presence => true
  validates :equipment, :presence => true

end
