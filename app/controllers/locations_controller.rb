class LocationsController < ApplicationController

  get '/locations' do
    @locations = Location.all
    erb :'/locations/index'
  end


  get '/:user_slug/locations/:location_id' do

    # binding.pry
    @user = User.find_by_id(session[:user_id])
    # user_slug = @user.slug

    @location = Location.find_by(id: params[:location_id])
    # location_slug = @location.slug

    @jackets = @location.jackets

    erb :'/locations/show'
  end


end
