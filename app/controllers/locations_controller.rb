class LocationsController < ApplicationController

  get '/:user_slug/locations/:location_id' do
    if current_user_logged_in?
      @user = current_user
      if @user.locations.include?(Location.find_by(id: params[:location_id]))
        @location = Location.find_by(id: params[:location_id])
      else
        session[:wrong_url] = "Oops, you can't see somebody else's locations!"
        redirect '/'
      end
      @jackets = @location.jackets
      erb :'/locations/show'
    else
      session[:wrong_url] = "Oops, you can't see somebody else's jackets!"
      redirect "/login"
    end
  end

end
