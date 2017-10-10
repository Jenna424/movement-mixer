class User < ActiveRecord::Base
  has_secure_password # user instance has @password attribute even though column in users table is password_digest
  # user instance must have @password attribute to be successfully saved to DB
  validates :username, :presence => true
  # user instance must have @username attribute to be successfully saved to DB
  validates :email, :presence => true
  # user instance must have @email attribute to be successfully saved to DB
  has_many :routines # a user instance has many routine instances (personalized workout plans)

  def generate_slug # instance method called on user instance returns slugged version of its @username attribute
    username.downcase.gsub(" ", "-") # call #username instance getter on user instance (self) to return its @username attribute and then
  end # make @username value all lowercase and replace any spaces with hyphens

  def self.find_by_username_slug(username_slug) # class method called on User class
    self.all.detect {|user| user.generate_slug == username_slug} # call #all on User class (self) to return array of all user instances
  end # Iterate over array of all user instances and return the first user instance whose slugged version of its @username attribute (returned by calling #generate_slug instance method on user instance) equals the username_slug argument passed into class method
end
