require 'rack-flash'

class RoutinesController < ApplicationController
  use Rack::Flash

  get '/routines' do # route is GET request to localhost:9393/routines, the index page to display all workout routines designed by all users
    if logged_in? # user can only see index of all workout routines if user is logged in
      @all_routines = Routine.all # @all_routines stores array of all routine instances
      erb :'routines/index' # render the index.erb view file, found within the routines/ subfolder in the views/ folder
    else # Otherwise, if the user is NOT logged in
      flash[:message] = "You must log in to view the index of all workout routines."
      redirect to "/login" # redirect to localhost:9393/login, which presents login form
    end
  end

  get '/routines/new' do # route is GET request to localhost:9393/routines/new to allow a logged in user to create a new workout routine
    if logged_in? # a user must be logged in to create a new workout routine
      erb :'routines/create_routine' # render the create_routine.erb view file, found in the routines/ subfolder within the views/ folder
    else
      flash[:message] = "You must log in to design a personalized workout plan."
      redirect to '/login'
    end
  end

end
