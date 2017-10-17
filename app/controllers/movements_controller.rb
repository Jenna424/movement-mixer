require 'rack-flash'

class MovementsController < ApplicationController
  use Rack::Flash

  get '/movements' do # index action - route is GET request to localhost:9393/movements to display all movements included in all workout routines
    if logged_in? # the user can only see the index of all exercise movements if logged in
      @all_movements = Movement.all # @all_movements is an array storing all movement instances
      erb :'movements/movements_index' # render the movements_index.erb view file, which is found in the movements/ subfolder within the views/ folder
    else
      redirect to '/login'
    end
  end

  get '/movements/new' do # route is GET request to localhost:9393/movements/new to present form to create new movement
    if logged_in?
      erb :'movements/create_movement' # render create_movement.erb view file, found within the movements/ subfolder in the views/ folder
    else
      redirect to '/login'
    end
  end
end
