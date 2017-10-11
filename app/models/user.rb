class User < ActiveRecord::Base
  has_secure_password # user instance has @password attribute even though column in users table is password_digest
  # user instance must have @password attribute to be successfully saved to DB
  validates :name, :presence => true
  # user instance must have @username attribute to be successfully saved to DB
  validates :email, :presence => true
  # user instance must have @email attribute to be successfully saved to DB
  has_many :routines # a user instance has many routine instances (personalized workout plans)
end
