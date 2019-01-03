require 'sinatra'
class App < Sinatra::Base

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

  # get '/registrations/signup' do
  #   erb :'application/signup'
  # end

end
