# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app (I built an MVC Sinatra CRUD app using Sinatra, ActiveRecord and Ruby. It includes a config.ru rackup file)
- [x] Use ActiveRecord for storing information in a database (users, routines, movements, movement_routines tables)
- [x] Include more than one model class (User, Routine, Movement, MovementRoutine classes)
- [x] Include at least one has_many relationship (a user instance has many routine instances, and a routine instance belongs to a single user instance. Accordingly, I used the has_many :routines ActiveRecord macro in the User class and the belongs_to :user macro in the Routine class)
- [x] Include user accounts (get '/signup' renders create_user.erb view, which displays form to create a new user. I used authentication (specifically #authenticate method provided by has_secure_password macro) to ensure that the user is who they claim to be when logging them in by setting the :user_id key of the session hash equal to the @id attribute value of the user instance. I used password encryption to prevent hacking. Salted, hashed passwords are stored in the password_digest column of the users table.
- [x] Ensure that users can't modify content created by other users (use conditional logic to ensure that a logged-in user can only edit and delete workout routines and exercise movements that he/she designed.
- [x] Include user input validations (ActiveRecord validations in my models ensure that user, routine and movement instances cannot be saved to the database unless each instance has all its required attribute values set from the values users submit in the form fields. A user instance must have @name, @email and @password attributes. A routine instance must have @name, @training_type, @duration, @difficulty_level and @equipment attributes. A movement instance must have @name, @instructions, @target_area, @reps, @sets, @modification and @challenge attributes).
- [x] Display validation failures to user with error message (As an example, the get '/signup' route renders the create_user.erb view file, which presents the form to create a new user account. If the user tries to submit the form without entering values in all required fields for name, email and password, the user is redirected to the signup page again. Using rack-flash gem, I display a flash message at the top of the signup page, alerting the user that they must fill in all three form fields to successfully register for the app)
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
