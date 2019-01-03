require "./config/environment"
require "./app/models/users"

class ApplicationController < Sinatra::Base

  set :views, proc { File.join(root, '../views/') }
  register Sinatra::Twitter::Bootstrap::Assets

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    # "you are logged in as #{session[:email]}"
    erb :"application/index"
  end


# methods that allow us to add logic to our views:
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
      User.find(session[:user_id])
    end

  end
end
