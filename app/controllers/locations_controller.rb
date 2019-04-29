class LocationsController < ApplicationController

  get '/:user_slug/locations/:location_id' do
    @user = User.find_by_id(session[:user_id])
    @location = Location.find_by(id: params[:location_id])
    @jackets = @location.jackets
    erb :'/locations/show'
  end

end
