require 'sinatra' #imports all functionality from sinatra gem including rack middleware (which connects to the database)
class App < Sinatra::Base # any instance of our class App will have all the functionality of the Sinatra class

  cofigure do
    set :public_folder, 'public'
    set :views, 'app/views'
    #turns cookies on
    enable :sessions
    set :session_secret, "carcollection"
  end

  get '/' do
    "Hello, world!"
  end

end
