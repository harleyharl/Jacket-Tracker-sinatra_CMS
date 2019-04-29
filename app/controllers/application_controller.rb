require "./config/environment"
require "./app/models/users"
require_relative '../models/concerns/slugifiable.rb'

class ApplicationController < Sinatra::Base

  set :views, proc { File.join(root, '../views/') }
  register Sinatra::Twitter::Bootstrap::Assets

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :"application/index"
  end


  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def login(username, password)
      user = User.find_by(username: username)
      if user && user.authenticate(password)  #if the user exists, set local variable user
          session[:session_id] = user.id
      else
        redirect '/login'
      end
    end

    def logout!
      session.clear
    end

    def current_user
      User.find(session[:user_id]) || User.find_by_slug(params[:user_slug])
    end

    def user_exists
      !!User.find_by(username: params[:username])
    end

    def clear_errors
      session[:fail_user_exists] = nil
      session[:fail_something_missing] = nil
      session[:fail] = nil
      session[:new_jacket_error] = nil
    end

  end
end
