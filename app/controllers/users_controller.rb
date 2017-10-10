class UsersController < ApplicationController
  get '/signup' do # route is GET request to localhost:9393/signup, where form is presented to create a new user
    if !logged_in? # If a user is NOT already logged in,
      erb :'users/create_user' # render create_user.erb view file found in users/ subfolder within views/ folder
    else # otherwise, if the user is already logged in, they will not see signup form and instead,
      redirect to '/routines' # user is redirected to localhost:9393/routines, where all routines are displayed
    end
  end
end
