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

  post '/movements' do # route receives data submitted in form to create new exercise movement
    if params[:movement].values.any? {|value| value.empty?} # if the user forgot to fill in any required field for movement attribute
      flash[:message] = "You must fill in Name, Instructions, Target Area, Number of Reps per Set, Number of Sets, Modification and Challenge fields to create a new exercise movement."
      redirect to "/movements/new"
    else # user filled in all required fields for movement attributes
      if params[:routine].values.all? {|value| value.empty?} # user did not create a new workout routine in which to use the new movement
        @movement = current_user.movements.create(params[:movement])
        # instantiate movement instance with its attribute set via mass assignment and automatically belonging to the logged-in user instance who created it
        # now @movement has user_id foreign key column value set, and we can call #user on @movement to return user instance to which it belongs
        # also, calling current_user.movements will return array of movement instances belonging to this user, which includes @movement
        @movement.routine_ids = params[:movement][:routine_ids] if params[:routine_ids]
        # if there are no existing workout routines already created by the user, params hash won't contain "routine_ids" key pointing to array of @id attribute values
        # tell the movement instance which of the user's existing routine instances it belongs to if there are existing routines for that user
        # now calling #routines on @movement returns array of routine instances created by that user in which the movement instance is found. And calling #movements on a routine that contains @movement will return array of movements including @movement
        flash[:message] = "Your exercise movement was successfully created!"
        redirect to "/movements/#{@movement.generate_slug}"
      elsif params[:routine].values.all? {|value| value != ""}
        @routine = current_user.routines.create(params[:routine]) # create and save to DB a routine instance with its attributes set via mass assignment and automatically belonging to the user instance who's currently logged in (and who created the routine)
        @movement = @routine.movements.create(params[:movement]) # create and save to DB a movement instance with its attributes set via mass assigment and immediately included in the routine instance that we just created, which belongs to the currently logged-in user. Now we can call routine.movements and movement.routines
        @movement.routine_ids = params[:movement][:routine_ids] # tell the movement instance which existing workout routines it's found in
        @movement.user = current_user # tell the movement that it belongs to the current user (this sets the foreign key)
        @movement.save # save changes, user_id foreign key value is inserted into row representing @movement instance in movements table
        flash[:message] = "Your exercise movement was successfully updated and is now included in a brand new workout routine!"
        redirect to "/movements/#{@movement.generate_slug}"
      else
        flash[:message] = "You must fill in Name, Training Type, Duration, Difficulty Level and Equipment form fields to successfully create a new workout routine in which to perform your new exercise."
        redirect to "/movements/#{@movement.id}/edit"
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
    elsif @movement.user == current_user # the logged in user is returned by calling #current_user helper method.
      erb :'movements/edit_movement' # if it's true that the @movement instance belongs to (was created by) the logged-in user, render the edit_movement.erb view file, which is found within the movements/ subfolder in the views/ folder
    else # otherwise, the user is currently logged in, but the movement they are trying to edit does NOT belong to them, so they cannot edit it
      flash[:message] = "You are not authorized to edit an exercise movement designed by a different user."
      redirect to '/movements' # redirect user to the index page displaying all exercise movements
    end
  end

  patch '/movements/:slug' do # route receives data submitted in form to edit an exercise movement
    @movement = Movement.find_by_slugged_name(params[:slug]) # find movement instance by its slugged @name attribute value
    # params[:movement] is the movement hash nested inside params hash. Calling #values on this movement hash returns array of movement hash values.
    if params[:movement].values.any? {|value| value.empty?} # If the user left any field blank for a movement attribute (value is empty string)
      flash[:message] = "You must fill in Name, Instructions, Target Area, Number of Reps per Set, Number of Sets, Modification and Challenge fields to successfully edit your exercise movement."
      redirect to "/movements/#{@movement.id}/edit" # user sees form to try editing exercise movement again
    else # user filled in all required fields for movement attributes
      if params[:routine].values.all? {|value| value.empty?} # the user did not create a new routine for the new movement to be found in - all fields for routine attributes are blank (values are empty strings)
        @movement.routine_ids = params[:movement][:routine_ids] # tell the movement instance which of the user's existing routines the movement will be performed in. Now we can call @movement.routines to return the array of routine instances in which the movement instance is used. Also, calling #movements on a routine instance that uses @movement will return array of movement instances, including @movement
        @movement.update(params[:movement]) # update attribute values of @movement instance (some might have been changed in edit form) and save changes to database
        flash[:message] = "Your exercise movement was successfully updated!"
        redirect to "/movements/#{@movement.generate_slug}" # show the movement that was just edited
      elsif params[:routine].values.all? {|value| value != ""} # user created a new routine for the new movement to be used in (all fields for routine attributes are not empty strings)
        @routine = current_user.routines.create(params[:routine]) # create and save to DB a routine instance with its attributes set via mass assignment and automatically belonging to the user instance who's currently logged in (and who the routine instance belongs to)
        @movement.routine_ids = params[:movement][:routine_ids] # tell the movement instance which existing workout routines it's found in
        @movement.routines << @routine # add the new routine just created to the movement instance's collection of routine instances in which it is used
        @movement.update(params[:movement]) # update the attribute values of the movement instance (some attributes may have been edited) and save changes to database
        @routine.movements << @movement # add the updated movement instance to the routine instance's array of movement instances performed in routine
        flash[:message] = "Your exercise movement was successfully updated and is now included in a brand new workout routine!"
        redirect to "/movements/#{@movement.generate_slug}" # show the exercise movement that was just edited
      else # the user left some required form fields for routine attributes blank, so routine is not valid
        flash[:message] = "You must fill in Name, Training Type, Duration, Difficulty Level and Equipment fields to create a new workout routine in which to perform your exercise."
        redirect to "/movements/#{@movement.id}/edit" # user sees form to try editing exercise movement again
      end
    end
  end

  delete '/movements/:slug' do # route receives data when user clicks Delete Exercise button on the show page of a single exercise movement
    @movement = Movement.find_by_slugged_name(params[:slug]) # find movement instance by its slugged @name attribute value
    if !logged_in? # if the user is not logged in, redirect to page with login form
      redirect to '/login'
    elsif @movement.user == current_user # if the movement instance requested for deletion belongs to the logged-in user
      @movement.delete # delete the movement instance
      flash[:message] = "Your exercise movement was successfully deleted."
      redirect to '/movements' # redirect user to movements index page, where their deleted exercise movement is no longer listed
    else # the user is logged in, but they cannot delete the exercise movement because it does NOT belong to that user
      flash[:message] = "You are not authorized to delete an exercise movement designed by a different user."
      redirect to '/movements'
    end
  end

end
