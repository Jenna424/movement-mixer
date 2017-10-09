class UsersController < ApplicationController
  get '/signup' do
    if !logged_in?
      erb :'users/create_user' # render create_user.erb view file found in users/ subfolder within views/ folder
    else
      redirect to '/routines'
    end
  end
end
