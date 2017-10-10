class User < ActiveRecord::Base
  has_many :routines # a user instance has many routine instances (personalized workout plans)

  has_secure_password # user instance has @password attribute even though table column is password_digest
# user instance must have @password attribute to be successfully saved to DB
  validates :username, :presence => true
  # user instance must have @username attribute to be successfully saved to DB
  validates :email, :presence => true
  # user instance must have @email attribute to be successfully saved to DB
end
