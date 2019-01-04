class JacketsController < ApplicationController

  get '/:user_slug/jackets' do
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      @jackets = @user.jackets
      erb :'/jackets/index'
    else
      redirect "/login"
    end
  end

  get '/jackets/new' do

    if !logged_in?
      redirect "/login"
    else

      @user = User.find_by_id(session[:user_id])

      @locations = @user.jackets.collect do |jacket|
        jacket.location
      end

      @locations.compact!

      @brands = Brand.all

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

    @user = User.find_by_id(session[:user_id])
    user_slug = @user.slug
    @jacket = Jacket.create

    #takes info from radio boxes for jacket type
    if params[:jacket][:jacket_type] && !params[:jacket][:jacket_type].empty? #if theres a box ticked
      @jacket.jacket_type = params[:jacket][:jacket_type] #set jacket type to that input
    end
    #or set jacket type with whats in the box
    if params[:jacket][:new_jacket_type] && !params[:jacket][:new_jacket_type].empty?
      @jacket.jacket_type = params[:jacket][:new_jacket_type]
    end

    if params[:jacket][:brand] && !params[:jacket][:brand].empty?
      @jacket.brand = Brand.find_or_create_by(name: params[:jacket][:brand])
    end

    #takes info from location radio boxes
    if params[:jacket][:location_id] && !!params[:jacket][:location_id] #if a location box is ticked -
      @location = Location.find_by_id(params[:jacket][:location_id])
      @jacket.location = @location #find the location by id and set the association
      @location.jackets << @jacket
    end

    if params[:jacket][:new_location] && !params[:jacket][:new_location].empty? #if the text box has content
      @location = Location.create(name: params[:jacket][:new_location])
      @jacket.location = @location #overwrite jackets location
      @location.jackets << @jacket
    end

    @user.jackets << @jacket
    @user.save
    @location.save

    redirect "/#{user_slug}/jackets"
    end

  end


  get '/jackets/:id' do
    # binding.pry
    @user = User.find_by_id(session[:user_id])
    @jacket = Jacket.find_by_id(params[:id])
    @more_users_jackets_of_same_type = @user.jackets.select do |jacket|
      jacket.jacket_type == @jacket.jacket_type
    end
    erb :'jackets/show'
  end

  delete '/jackets/:id/delete' do
    @jacket = Jacket.find_by_id(params[:id])
    if logged_in? && current_user.jackets.include?(@jacket)
        @jacket.delete
        redirect to '/jackets'
    else
      redirect to ("/login")
    end
  end



end
