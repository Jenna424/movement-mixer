require 'rack-flash'

class RoutinesController < ApplicationController
  use Rack::Flash

  get '/routines' do # route is GET request to localhost:9393/routines, the index page to display all workout routines designed by all users
    if logged_in? # user can only see index of all workout routines if user is logged in
      @all_routines = Routine.all # @all_routines stores array of all routine instances
      erb :'routines/routines_index' # render the routines_index.erb view file, found within the routines/ subfolder in the views/ folder
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
    @routine = current_user.routines.build(params[:routine])
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
        # tell the routine instance that it belongs to the user instance currently logged in
        # argument passed to #create is movement hash nested inside params hash
        # movement hash looks like: {"name" => "@name", "instructions" => "@instructions", "target_area" => "@target_area", "reps" => "@reps", "modification" => "@modification", "challenge" => "@challenge"}
        # instantiate and save to DB a movement instance with its attribute values set via mass assignment and
        # shovel this new movement instance into the array of movement instances belonging to the @routine instance
        flash[:message] = "You successfully created a new workout routine!"
        redirect to "/routines/#{@routine.generate_slug}" # show the user the workout routine they just created
      end
    else # otherwise, the routine instance was not saved to DB because user forgot to fill in required form fields
      flash[:message] = "You must fill in Name, Training Type, Duration, Difficulty Level and Equipment fields to create a new workout routine."
      redirect to '/routines/new' # redirect to localhost:9393/routines/new, where user sees form to try creating new routine again
    end
  end

  get '/routines/:slug' do # route is GET request to localhost:9393/routines/slugged-version-of-@name-attribute-value-of-routine-instance-goes-here
    if logged_in? # the user can only view a routine if logged in
      @routine = Routine.find_by_slugged_name(params[:slug])
      erb :'routines/show_routine' # render the show_routine.erb view file found within the routines/ subfolder in the views/ folder
    else
      redirect to '/login'
    end
  end

  get '/routines/:id/edit' do # route is GET request to localhost:9393/routines/@id of whatever routine instance user wants to edit replaces :id route variable here/edit
    @routine = Routine.find_by(id: params[:id]) # find the routine instance by its @id value, which = params[:id]

    if !logged_in? # prevent someone who's not logged in from viewing edit form; redirect to login page
      redirect to '/login'
    elsif current_user.routines.include?(@routine) # Calling #current_user will return the user instance who's currently logged in. If the routine instance requested to edit belongs to the user instance who's currently logged in (i.e. the routine instance is included in logged-in user instance's array of routine instances),
      erb :'routines/edit_routine' # render the edit_routine.erb view file, which is found in the routines/ subfolder within the views/ folder
    else # otherwise, if a user who IS logged in tries to access the edit form of a routine that does NOT belong to them
      flash[:message] = "You are not authorized to edit the requested routine."
      redirect to '/routines' # redirect logged-in user to the routines index page
    end
  end

  patch '/routines/:slug' do # PATCH request route receives data submitted in form to edit the user's routine
    @routine = Routine.find_by_slugged_name(params[:slug])

    if params[:routine].values.any? {|value| value.empty?}
      flash[:message] = "You must fill in Name, Training Type, Duration, Difficulty Level and Equipment form fields to edit your workout routine."
      redirect to "/routines/#{@routine.id}/edit"
    else # user filled in all fields pertaining to routine attributes, but now check if user created a new, valid movement to add to their routine:
      if params[:movement].values.all? {|value| value.empty?} # user did not create a new movement for the routine (all form fields for creating a new movement were left blank, i.e., values are empty strings)
        @routine.update(params[:routine]) # update the attribute values of routine instance, some of which may have been changed, and save changes to DB
        flash[:message] = "Your workout routine was successfully updated!"
        redirect to "/routines/#{@routine.generate_slug}" # show user their routine that was either left the same or edited (without a new movement added to it)
      elsif params[:movement].values.all? {|value| value != ""} # if all form fields to create a new movement for the routine were filled in, the new movement is valid
        @routine.update(params[:routine])
        @routine.movements << Movement.create(params[:movement]) # create and save to DB a movement instance with its attributes set via mass assignment and shovel it into the routine instance's array of movement instances
        flash[:message] = "Your workout routine was successfully updated!"
        redirect to "/routines/#{@routine.generate_slug}" # show user their routine that was edited (including a new movement successfully added to it)
      else # if the user filled in only SOME of the required fields to create a new movement for their routine, the movement is invalid so,
        flash[:message] = "You must fill in Name, Instructions, Target Area, Reps, Modification and Challenge form fields to create a new, valid movement to add to your routine."
        redirect to "/routines/#{@routine.id}/edit"
      end
    end
  end

end
