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
