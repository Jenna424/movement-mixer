class User < ActiveRecord::Base
  has_many :routines # a user instance has many routine instances (personalized workout plans)

  has_secure_password

  validates :username, :presence => true
  # user instance must have @username attribute to be successfully saved to DB
  validates :email, :presence => true
  # user instance must have @email attribute to be successfully saved to DB
end
