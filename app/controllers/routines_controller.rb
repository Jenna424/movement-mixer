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

  post '/routines' do # route receives data submitted in form to create a new routine.
    @routine = Routine.new(params[:routine])
    # The argument passed to #new is the routine hash (nested inside params hash)
    # routine hash looks like: {"name" => "@name value", "training_type" => "@training_type value", "duration" => "@duration value", "difficulty_level" => "@difficulty_level value", "equipment" => "@equipment value", "movement_ids" => [array of string @id values of existing movement instances belonging to routine instance]}
    # Instantiate @routine instance with its attribute values set via mass assignment, and
    # Now we can also call @routine.movements and the array of existing movement instances belonging to the @routine instance is returned
    if @routine.save # a routine instance will only be saved to DB if user filled in Name, Training Type, Duration, Difficulty Level and Equipment required form fields
      if params[:movement].values.detect {|value| value == ""}
        flash[:message] = "You must fill in all six fields to create a new exercise movement for your workout routine."
        redirect to "/routines/new" # present the form to try creating a new routine again
      else # if user filled in all fields to create a new movement belonging to the new routine
        @routine.movements << Movement.create(params[:movement])
        # argument passed to #create is movement hash nested inside params hash
        # movement hash looks like: {"name" => "@name", "instructions" => "@instructions", "target_area" => "@target_area", "reps" => "@reps", "modification" => "@modification", "challenge" => "@challenge"}
        # instantiate and save to DB a movement instance with its attribute values set via mass assignment and
        # shovel this new movement instance into the array of movement instances belonging to the @routine instance
        flash[:message] = "You've successfully created a new workout routine!"
        redirect to "/routines/#{@routine.generate_slug}" # show the user the workout routine they just created
      end
    else # otherwise, the routine instance was not saved to DB because user forgot to fill in required form fields
      flash[:message] = "You must fill in Name, Training Type, Duration, Difficulty Level and Equipment fields to create a new workout routine."
      redirect to '/routines/new' # redirect to localhost:9393/routines/new, where user sees form to try creating new routine again
    end
  end

  get '/routines/:slug' do # route is GET request to localhost:9393/routines/slugged-version-of-@name-attribute-value-of-routine-instance-goes-here
    @routine = Routine.find_by_slugged_name(params[:slug])
    erb :'routines/show' # render the show.erb view file found within the routines/ subfolder in the views/ folder
  end

end
