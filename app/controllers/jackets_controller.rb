class JacketsController < ApplicationController

  get '/:user_slug/jackets' do
    redirect_if_wrong_user
    @user = current_user
    @jackets = @user.jackets
    erb :'/jackets/index'
  end

  get '/:user_slug/jackets/new' do
    redirect_if_wrong_user
    @user = current_user
    @locations = @user.locations
    @jacket_types = @user.jackets.all.collect do |jacket|
      jacket.jacket_type
    end
    erb :'/jackets/new'
  end

  post '/jackets' do
    if !logged_in?
      redirect "/login"
    else
      @user = current_user
      @jacket = Jacket.new
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
        @location = Location.find_by(id: params[:jacket][:location_id])
        @jacket.location = @location
      end
      # protects my database from bad data by redirecting if some value is nil
      if @jacket.attributes_filled? #see Jacket instance method
        @jacket.save
        @user.jackets << @jacket
        redirect "/#{@user.slug}/jackets"
      else
        session[:new_jacket_error] = "Please try again. You'll need to enter a jacket type, brand and location in order to save a new jacket"
        redirect "/#{@user.slug}/jackets/new"
      end
    end
  end

  get '/:user_slug/jackets/:jacket_slug' do
    redirect_if_wrong_user
    @user = current_user
    if @user.jackets.include?(Jacket.find_by_slug(params[:jacket_slug]))
      @jacket = Jacket.find_by_slug(params[:jacket_slug])
    else
      session[:wrong_url] = "Oops, you can't see somebody else's jackets!"
      redirect '/'
    end
    erb :'jackets/show'
  end

  get '/:user_slug/jackets/:jacket_slug/edit' do
    redirect_if_wrong_user
    @user = current_user
    if @user.jackets.include?(Jacket.find_by_slug(params[:jacket_slug]))
      @jacket = Jacket.find_by_slug(params[:jacket_slug])
    else
      session[:wrong_url] = "Oops, you can't move somebody else's jackets!"
      redirect '/'
    end
    @locations = @user.locations
    erb :'jackets/edit'
  end

  patch '/:user_slug/jackets/:jacket_slug' do  #updates a jacket
    redirect_if_wrong_user
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

  delete '/jackets/:id/delete' do
    @jacket = Jacket.find_by_id(params[:id])
    @user = current_user
    if logged_in? && @user.jackets.include?(@jacket)
      @jacket.delete
      redirect to "#{@user.slug}/jackets"
    else
      redirect to ("/login")
    end
  end

end
