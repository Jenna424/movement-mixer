class MovementsController < ApplicationController
  get '/movements' do # route is GET request to localhost:9393/movements to display index of all movements included in all workouts
    @all_movements = Movement.all

    erb :'movements/index' # render the index.erb view file, which is found in the movements/ subfolder within the views/ folder
  end
end
