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

  get '/routines/new' do # route is GET request to localhost:9393/routines/new, where form is presented to create a new workout routine
    if logged_in? # a user must be logged in to create a new workout routine
      erb :'routines/create_routine' # render the create_routine.erb view file, found in the routines/ subfolder within the views/ folder
    else
      flash[:message] = "You must log in to design a personalized workout plan."
      redirect to '/login'
    end
  end
  # routine hash looks like: {"name" => "@name value", "training_type" => "@training_type value", "duration" => "@duration value", "difficulty_level" => "@difficulty_level value", "equipment" => "@equipment value", "movement_ids" => [array of string @id values of existing movement instances belonging to routine instance]}
  post '/routines' do # route receives data submitted in form to create new routine
    if params[:routine].values.any? {|value| value.empty?} # if user left any fields pertaining to routine attributes blank (value is empty string)
      flash[:message] = "You must fill in Name, Training Type, Duration, Difficulty Level and Equipment fields to create a new workout routine."
      redirect to '/routines/new' # redirect to localhost:9393/routines/new, where user sees form to try creating new routine again
    else # otherwise, the user filled in all required workout routine fields
      if params[:movement].values.all? {|value| value.empty?} # user did not create a new movement for the routine (all form fields for creating a new movement were left blank, i.e., values are empty strings)
        @routine = current_user.routines.create(params[:routine])
        # create @routine instance with its attributes set via mass assignment and immediately belonging to the user instance who's currently logged in
        @routine.movement_ids = params[:routine][:movement_ids] # params[:routine][:movement_ids] is the array of @id values of existing movement instances that belong to the routine instance (from the movement checkboxes the user selected in form to create routine)
        # Now we can also call @routine.movements and the array of existing movement instances belonging to the @routine instance is returned
        flash[:message] = "You successfully created a new workout routine!"
        redirect to "/routines/#{@routine.generate_slug}" # show the user the workout routine they just created (without having created a new exercise movement for it)
      elsif params[:movement].values.all? {|value| value != ""} # if all form fields to create a new movement for the new routine were filled in, the new movement is valid
        @routine = current_user.routines.create(params[:routine]) # create @routine instance with its attributes set via mass assignment and immediately belonging to the user instance who's currently logged in (who created it)
        @routine.movement_ids = params[:routine][:movement_ids] # the existing movement instances selected from checkboxes now belong to the routine instance
        new_movement = @routine.movements.create(params[:movement]) # create and save to DB a movement instance with its attributes set via mass assignment and immediately associated with the @routine instance
        # now we can call new_movement.routines to return array of routine instances (including @routine) in which new_movement movement instance is performed
        # we can also call @routine.movements to return array of movement instances (including new_movement) that are performed in that specific @routine
        new_movement.user = @routine.user # tell the new_movement instance that it belongs to the user instance who created it (the same user who created @routine)
        new_movement.save # call #save on new_movement instance to make sure its user_id foreign key column value is inserted into DB (since the movement instance belongs to the user who created it)
        flash[:message] = "You successfully created a new workout routine!"
        redirect to "/routines/#{@routine.generate_slug}" # show user the routine they just created (having also created a new exercise movement for it)
      else # if the user filled in only SOME of the required fields to create a new movement for their routine, the movement is invalid so,
        flash[:message] = "You must fill in Name, Instructions, Target Area, Number of Reps per Set, Number of Sets, Modification and Challenge fields to create a new exercise movement to add to your workout routine."
        redirect to "/routines/new" # present the form to try creating a new routine again
      end
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
      flash[:message] = "You are not authorized to edit a routine designed by a different user."
      redirect to '/routines' # redirect logged-in user to the routines index page
    end
  end

  patch '/routines/:slug' do # PATCH request route receives data submitted in form to edit the user's routine
    @routine = Routine.find_by_slugged_name(params[:slug])

    if params[:routine].values.any? {|value| value.empty?}
      flash[:message] = "You must fill in Name, Training Type, Duration, Difficulty Level and Equipment form fields to edit your workout routine."
      redirect to "/routines/#{@routine.id}/edit"
    else # All fields pertaining to routine attributes are filled in, but now check if user created a new, valid movement to add to their routine:
      if params[:movement].values.all? {|value| value.empty?} # user did not create a new movement for the routine (all form fields for creating a new movement were left blank, i.e., values are empty strings)
        @routine.movement_ids = params[:routine][:movement_ids] # update the existing movements belonging to the routine (from checkboxes)
        @routine.update(params[:routine]) # update the attribute values of routine instance, some of which may have been changed, and save changes to DB
        flash[:message] = "Your workout routine was successfully updated!"
        redirect to "/routines/#{@routine.generate_slug}" # show user their edited routine (without a new movement added to it)
      elsif params[:movement].values.all? {|value| value != ""} # if all form fields to create a new movement for the routine were filled in, the new movement is valid
        @routine.movement_ids = params[:routine][:movement_ids]
        @routine.update(params[:routine])
        new_movement = @routine.movements.create(params[:movement])
        new_movement.user = current_user
        new_movement.save
        flash[:message] = "Your workout routine was successfully updated!"
        redirect to "/routines/#{@routine.generate_slug}" # show user their routine that was edited (including a new movement successfully added to it)
      else # if the user filled in only SOME of the required fields to create a new movement for their routine, the movement is invalid so,
        flash[:message] = "You must fill in Name, Instructions, Target Area, Number of Reps per Set, Number of Sets, Modification and Challenge form fields to create a new, valid movement to add to your routine."
        redirect to "/routines/#{@routine.id}/edit"
      end
    end
  end

  delete '/routines/:id/delete' do # route receives data when Delete Routine button (form) is clicked on the show page of routine wished to be deleted
    if logged_in? # if the user is logged in
      @routine = Routine.find_by(id: params[:id]) # find the routine instance by its @id attribute value, which = params[:id]
      if current_user.routines.include?(@routine) # if the routine instance is included in the array of routine instances belonging to the currently logged-in user,
        @routine.delete # delete the routine
        flash[:message] = "Your workout routine was successfully deleted."
        redirect to '/routines' # browser navigates to index page of all routines created by all users
      else # the user is logged in, but the requested routine does NOT belong to them, so user cannot delete it
        flash[:message] = "You are not authorized to delete a routine designed by a different user."
        redirect to '/routines'
      end
    end
    redirect to '/login' # if user is not logged in, show login form to sign in
  end

end
