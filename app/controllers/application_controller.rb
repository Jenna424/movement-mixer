require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "movement_mixer_secret"
  end

  get '/' do # root route is GET request to localhost:9393, the homepage
    erb :index # render the index.erb view file, which is found in the views/ folder
  end

  helpers do
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in? # the truthiness of calling #current_user instance method
      !!current_user
    end
  end

end
