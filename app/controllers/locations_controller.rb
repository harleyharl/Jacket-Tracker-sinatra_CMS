class LocationsController < ApplicationController

  get '/locations' do
    @locations = Location.all
    erb :'/locations/index'
  end


  get '/locations/:id' do
    #i only want to see my users locations
    # @user = User.find_by_id(session[:user_id])
    # @user.jackets.each do |jacket|
    #   jacket.location
    # end
    @location = Location.find_by(id: params[:id])
    # binding.pry
    erb :'/locations/show'
  end

end
