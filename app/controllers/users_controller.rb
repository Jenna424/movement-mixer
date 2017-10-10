require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do # route is GET request to localhost:9393/signup, where form is presented to create a new user
    if !logged_in? # If a user is NOT already logged in,
      erb :'users/create_user' # render create_user.erb view file found in users/ subfolder within views/ folder
    else # otherwise, if the user is already logged in, they will not see signup form and instead,
      redirect to '/routines' # user is redirected to localhost:9393/routines, where all routines are displayed
    end
  end

  post '/signup' do # route receives data submitted in form to create new user
    @user = User.new(params) # instantiate user instance with its attributes set via mass assignment
    # user instance is successfully saved to DB if ALL form fields for username, email and password are filled out
    if @user.save
      session[:user_id] = @user.id # log in the newly created user
      redirect to '/routines' # newly created, logged-in user sees index page of routines designed by all users
    else # otherwise, if the user left username, email or password form field blank (value is empty string)
      erb :'users/create_user' # render create_user.erb view file, which is found in the users/ subfolder in views/ folder to try registering again
    end
  end

  get '/login' do # route is GET request to localhost:9393/login, where user sees login form
    if logged_in? # a user who is already logged in will see the routines index page instead of login form
      redirect to '/routines'
    else # otherwise, if the user is NOT already logged in, they should see the login form
      erb :'users/login' # render the login.erb view file, found within the users/ subfolder within the views/ folder
    end
  end

  post '/login' do # route receives data submitted in login form
    @user = User.find_by(username: params[:username]) # find user instance by its @username attribute value (whatever was entered in username field in login form)

    if @user && @user.authenticate(params[:password]) # if a user instance exists with that @username value and if the user authenticates with that password,
      session[:user_id] = @user.id # log in the user
      redirect to "/routines" # redirect user to localhost:9393/routines, the index page where all routines are listed
    else # if a valid user is NOT found,
      flash[:message] = "You entered an invalid username and password combination. Please try logging in again."
      erb :'users/login' # redirect to localhost:9393/login so user can try logging in again
    end
  end

end
