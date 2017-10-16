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

  get '/movements/new' do # route is GET request to localhost:9393/movements/new, which presents the form to create a new movement
    if logged_in? # if the user is logged in, user is able to create a new exercise movement
      erb :'movements/create_movement' # render the create_movement.erb view file, which is found in the movements/ subfolder within the views/ folder
    else
      redirect to '/login'
    end
  end

  post '/movements' do # route receives the data submitted in form to create a new movement
    if params[:movement].values.any? {|value| value.empty?} # if the user left any fields pertaining to movement attributes blank (value is empty string)
      flash[:message] = "You must fill in Name, Instructions, Target Area, Reps, Modification and Challenge fields to create a new exercise movement."
      redirect to '/movements/new' # present form to try creating new movement again
    else # otherwise, the user filled in all required exercise movement fields.
      if params[:routine].values.all? {|value| value.empty?} # the user did not create a new routine for that new movement to be found in. all form fields for new routine were left blank (empty strings)
        @movement = Movement.create(params[:movement]) # create movement instance with its attributes set via mass assignment
        @movement.routine_ids = params[:movement][:routine_ids]
        # now we can call @movement.routines to return array of existing routine instances that the movement instance is included in
        # and we can also call routine.movements to return array of movement instances (including @movement) belonging to that routine instance
        flash[:message] = "You successfully created a new exercise movement!"
        redirect to "/movements/#{@movement.generate_slug}"
      elsif params[:routine].values.all? {|value| value != ""} # the user filled in all fields to create a new routine for the new movement to be found in (all values are NOT empty strings)
        @movement = Movement.create(params[:movement])
        @movement.routine_ids = params[:movement][:routine_ids]
        Routine.create(params[:routine]).movements << @movement
        # create a new routine instance with its attributes set via mass assignment and save it to DB
        # after shoveling, @movement is in the array of movement instances found in the new routine instance that we just created
        # and when we call @movement.routines, an array of routine instances in which the movement instance is used is returned. This array includes the routine we just created.
        flash[:message] = "You successfully created a new exercise movement used in a new workout routine!"
        redirect to "/movements/#{@movement.generate_slug}"
      else # user left some of the form fields blank for creating a new routine for the new movement to be used in
        flash[:message] = "You must fill in Name, Training Type, Duration, Difficulty Level and Equipment fields to create a new workout routine."
        redirect to '/movements/new'
      end
    end
  end

  get '/movements/:slug' do # show action - route is GET request to localhost:9393/slugged-version-of-@name-attribute-value-of-movement-instance-wish-to-be-shown-goes-here
    if logged_in? # the user can only view a single exercise movement if they're logged in
      @movement = Movement.find_by_slugged_name(params[:slug])
      erb :'movements/show_movement' # render the show_movement.erb view file, which is found within the movements/ subfolder within the views/ folder
    else
      redirect to '/login'
    end
  end

  get '/movements/:id/edit' do # route is GET request to localhost:9393/movements/@id-attribute-value-of-movement-instance-wished-to-be-edited-goes-here/edit
    @movement = Movement.find_by(id: params[:id]) # find movement instance by its @id attribute value, which = params[:id], i.e., whatever user typed into URL to replace :id route variable
    if !logged_in? # the user can only edit a movement instance that belongs to them if they're logged in, so if they're not logged in
      redirect to '/login' # redirect user to the page that presents login form
    elsif current_user.movements.include?(@movement) # the logged in user is returned by calling #current_user helper method. If @movement (the movement instance requested to be edited) is found in the logged-in user's array of movement instances belonging to it,
      erb :'movements/edit_movement' # render the edit_movement.erb view file, which is found within the movements/ subfolder in the views/ folder
    else # otherwise, the user is currently logged in, but the movement they are trying to edit does NOT belong to them, so they cannot edit it
      flash[:message] = "You are not authorized to edit an exercise movement created by a different user."
      redirect to '/movements' # redirect user to the index page displaying all exercise movements
    end
  end

end
