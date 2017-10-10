class UsersController < ApplicationController
  get '/signup' do # route is GET request to localhost:9393/signup, where form is presented to create a new user
    if !logged_in? # If a user is NOT already logged in,
      erb :'users/create_user' # render create_user.erb view file found in users/ subfolder within views/ folder
    else # otherwise, if the user is already logged in, they will not see signup form and instead,
      redirect to '/routines' # user is redirected to localhost:9393/routines, where all routines are displayed
    end
  end

  post '/signup' do # route receives data submitted in form to create new user
    # if the user left username, email or password fields blank (value is empty string)
    if params.values.any?{|v| v == ""} # calling #values on params hash returns array of hash values. Calling #any? returns true if any element in array is empty string
      redirect to '/signup' # redirect to registration page to try signing up again
    else
      @user = User.create(params) # instantiate user instance with attributes set via mass assignment
      session[:user_id] = @user.id # log in the new user
      erb :'users/show' # show action to display user just created - render the show.erb view file found within the users/ subfolder in the views/ folder
    end
  end

end
