class LocationsController < ApplicationController

  get '/locations' do
    @locations = Location.all
    erb :'/locations/index'
  end


  get '/locations/:id' do
    @location = Location.find_by(id: params[:id])
    # binding.pry
    erb :'/locations/show'
  end

end
