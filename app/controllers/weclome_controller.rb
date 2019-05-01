class WelcomeController < ApplicationController
  get '/' do
    if logged_in?
      @user = User.find_by(id: session[:user_id])
      erb :"welcome/index"
    else
      redirect '/login'
    end
  end
end
