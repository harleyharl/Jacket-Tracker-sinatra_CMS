class JacketsController < ApplicationController

  get '/:user_slug/jackets' do
    if current_user_logged_in?
      @user = current_user
      @jackets = @user.jackets
      erb :'/jackets/index'
    else
      session[:wrong_url] = "Oops, you can't see somebody else's jackets!"
      redirect "/login"
    end
  end

  get '/:user_slug/jackets/new' do
    if !current_user_logged_in?
      session[:wrong_url] = "Oops, you can't see somebody else's jackets!"
      redirect "/login"
    else
      @user = current_user
      @locations = @user.locations
      @jacket_types = @user.jackets.all.collect do |jacket|
        jacket.jacket_type
      end
      erb :'/jackets/new'
    end
  end

  post '/jackets' do
    if !logged_in?
      redirect "/login"
    else
      @user = User.find_by(id: session[:user_id])
      @jacket = Jacket.new #sets relationship
      #takes info for jacket type(text box overrides any radio buttons ticked)
      if params[:jacket][:new_jacket_type] && !params[:jacket][:new_jacket_type].empty? #if theres text input
        @jacket.jacket_type = params[:jacket][:new_jacket_type].chomp #set jacket type
      elsif params[:jacket][:jacket_type] && !params[:jacket][:jacket_type].empty? #if theres a box ticked
        @jacket.jacket_type = params[:jacket][:jacket_type].chomp #set jacket type to that input
      end
      # if theres something entered for the brand set the brand
      if params[:jacket][:brand] && !params[:jacket][:brand].empty?
        @jacket.brand = Brand.find_or_create_by(name: params[:jacket][:brand].chomp)
      end
      #takes info from location radio boxes. text input overrides radio button
      if params[:jacket][:new_location] && !params[:jacket][:new_location].empty? #if the text box has content
        @location = Location.find_or_create_by(name: params[:jacket][:new_location].chomp)
        @jacket.location = @location
      elsif params[:jacket][:location_id] && !!params[:jacket][:location_id] #if a location box is ticked -
        @location = Location.find_by_id(params[:jacket][:location_id])
        @jacket.location = @location
      end
      # protects my database from bad data by redirecting if some value is nil
      if @jacket.attributes_filled? #see Jacket instance method
        user_slug = @user.slug
        @jacket.user = @user
        @location.jackets << @jacket
        @user.jackets << @jacket
        redirect "/#{user_slug}/jackets"
      else
        session[:new_jacket_error] = "Please try again. You'll need to enter a jacket type, brand and location in order to save a new jacket"
        redirect '/jackets/new'
      end
    end
  end

  get '/:user_slug/jackets/:jacket_slug' do
    if current_user_logged_in?
      @user = current_user
      @jacket = Jacket.find_by_slug(params[:jacket_slug])
      erb :'jackets/show'
    else
      session[:wrong_url] = "Oops, you can't see somebody else's jackets!"
      redirect "/login"
    end
  end

  get '/:user_slug/jackets/:jacket_slug/edit' do
    if !current_user_logged_in?
      session[:wrong_url] = "Oops, you can't move somebody else's jackets!"
      redirect "/login"
    else
      @user = current_user
      @locations = @user.locations
      @jacket = @user.jackets.find_by_slug(params[:jacket_slug]) #see slugifiable
      erb :'jackets/edit'
    end
  end

  patch '/:user_slug/jackets/:jacket_slug' do  #updates a jacket
    if !logged_in?
      redirect "/login"
    else
      # binding.pry
      @user = current_user
      @jacket = @user.jackets.find_by_slug(params[:jacket_slug])
      # takes text input or on radio button input
      if params[:jacket][:new_location] && !params[:jacket][:new_location].empty?
        @location = Location.find_or_create_by(name: params[:jacket][:new_location].chomp)
        @jacket.location = @location #overwrite jackets location
      elsif params[:jacket][:location_id] && !!params[:jacket][:location_id] #if a location box is ticked -
        @location = Location.find_by(id: params[:jacket][:location_id])
        @jacket.location = @location #find the location by id and set the association
      end
      @location.jackets << @jacket
      erb :'jackets/show'
    end
  end

  delete '/jackets/:id/delete' do
    @jacket = Jacket.find_by_id(params[:id])
    @user = User.find_by(id: session[:user_id])
    if logged_in? && @user.jackets.include?(@jacket)
      @jacket.delete
      redirect to "#{@user.slug}/jackets"
    else
      redirect to ("/login")
    end
  end

end
