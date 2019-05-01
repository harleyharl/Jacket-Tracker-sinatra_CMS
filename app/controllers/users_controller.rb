class UsersController < ApplicationController

  get '/signup' do
    if logged_in? #logged in user is redirected to their jackets index
      @user = current_user
      user_slug = @user.slug
      redirect "/#{user_slug}/jackets"
    else
      erb :"users/new"
    end
  end

  post '/signup' do
    if user_exists #see ApplicationController methods
      session[:fail_user_exists] = "That user already exists"
      redirect '/signup'
    elsif params[:username].empty? || params[:password].empty?
      session[:fail_something_missing] = "Looks like you didn't fill something in, please try again"
      redirect '/signup'
    elsif !params[:username].empty? && !params[:password].empty? && !user_exists #checks to make sure both fields are not empty and the user doesn't exist already
      @user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = @user.id
      user_slug = @user.slug
      redirect "/#{user_slug}/jackets"
    else
      session[:fail] = "Sorry, something went wrong. Please try again"
      redirect '/signup'
    end
  end

  get '/login' do
    if logged_in?
      @user = User.find_by(id: session[:user_id])
      user_slug = @user.slug
      redirect "/"
    else
      clear_errors
      erb :"users/login"
    end
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      user_slug = @user.slug
      redirect "/#{user_slug}/jackets"
    else
      session[:no_account_error] = "You need to create an account to log in."
      erb :'users/login'
    end
  end

  post '/logout' do
    logout!
    redirect '/'
  end

end
