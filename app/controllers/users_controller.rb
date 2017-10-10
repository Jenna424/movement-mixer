class UsersController < ApplicationController
  get '/signup' do # route is GET request to localhost:9393/signup, where form is presented to create a new user
    if !logged_in? # If a user is NOT already logged in,
      erb :'users/create_user' # render create_user.erb view file found in users/ subfolder within views/ folder
    else # otherwise, if the user is already logged in, they will not see signup form and instead,
      redirect to '/routines' # user is redirected to localhost:9393/routines, where all routines are displayed
    end
  end

  post '/signup' do # route receives data submitted in form to create new user
    user = User.new(params) # instantiate user instance with its attributes set via mass assignment
    # user instance is successfully saved to DB if ALL form fields for username, email and password are filled out
    if user.save
      session[:user_id] = user.id # log in the newly created user
      redirect to '/routines' # newly created, logged-in user sees index page of routines designed by all users
    else # otherwise, if the user left username, email or password fields blank (value is empty string)
      redirect to '/signup' # redirect to registration page to try signing up again
    end
  end

end
