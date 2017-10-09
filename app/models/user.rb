class User < ActiveRecord::Base
  has_many :routines # a user instance has many routine instances (personalized workout plans)
end
