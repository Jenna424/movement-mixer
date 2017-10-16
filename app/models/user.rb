class User < ActiveRecord::Base
  include Sluggable::InstanceMethods
  extend Sluggable::ClassMethods

  has_secure_password # user instance has @password attribute even though column in users table is password_digest
  # user instance must have @password attribute to be successfully saved to DB
  validates :name, :presence => true
  # user instance must have @name attribute to be successfully saved to DB
  validates :email, :presence => true
  # user instance must have @email attribute to be successfully saved to DB
  has_many :routines # a user instance has many routine instances (personalized workout plans)
  # since a user instance has many routine instances, and each routine instance has many movement instances,
  has_many :movements, through: :routines # a user instance has many movement instances through the routine instances that belong to that user
end
