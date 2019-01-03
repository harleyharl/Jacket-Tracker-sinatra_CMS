class UsersController < ApplicationController

  # get "/user" do
  #

  get '/signup' do
    if logged_in? #logged in user can't even get to signup page
      redirect '/jackets'
    else
      erb:"users/new"
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty? #checks to make sure both fields are not empty
      @user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = @user.id
      redirect "/jackets"
    else
      redirect "/signup"
    end
  end

  get '/login' do
    # login(username, password)
  end

  post '/users' do
    # binding.pry
    if User.find_by(username: params[:username])
      redirect '/jackets'
    else
      @user = User.create(username: params[:username], password: params[:password])
      login(@user.username, @user.password)
      redirect '/jackets'
  end
    # session[:session_id] = @user.id
    if @user.save
      login(params[:username], params[:password])
      redirect '/jackets'
    else
      erb :"users/new"
    end
  end

  get '/logout' do
    logout!
    redirect '/'
  end

end
