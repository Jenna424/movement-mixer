class RoutinesController < ApplicationController
  get '/routines' do # route is GET request to localhost:9393/routines, the index page to display all workout routines designed by all users
    @all_routines = Routine.all # @all_routines stores array of all routine instances

    erb :'routines/index' # render the index.erb view file, found within the routines/ subfolder in the views/ folder
  end
end
