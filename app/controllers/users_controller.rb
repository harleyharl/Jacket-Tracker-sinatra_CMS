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
    erb :"users/login"
  end

  post "/login" do
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect "/jackets"
      else
          redirect "/failure"
      end
  end

  post '/users' do

    if User.find_by(username: params[:username])
      redirect '/jackets'
    else
      @user = User.create(username: params[:username], password: params[:password])
      login(@user.username, @user.password)
      redirect '/jackets'
    end

    if @user.save
      login(params[:username], params[:password])
      redirect '/jackets'
    else
      erb :"users/new"
    end

  end

  post '/logout' do
    logout!
    redirect '/'
  end

end
