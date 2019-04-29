require_relative '../models/concerns/slugifiable.rb'

class JacketsController < ApplicationController

  include Slugifiable #so we can use as instance method
  extend Slugifiable #so we can use as class method for methods like Artist.find_by_slug

  get '/:user_slug/jackets' do
    if logged_in?
      # binding.pry
      @user = current_user
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

      @user = current_user

      #means when a user has nothing in a single location it disappears from options
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
      @user = current_user
      user_slug = @user.slug
      @jacket = Jacket.new #sets relationship
      #takes info for jacket type(text box overrides any radio buttons ticked)
      if params[:jacket][:new_jacket_type] && !params[:jacket][:new_jacket_type].empty? #if theres text input
        @jacket.jacket_type = params[:jacket][:new_jacket_type].chomp #set jacket type
      elsif params[:jacket][:jacket_type] && !params[:jacket][:jacket_type].empty? #if theres a box ticked
        @jacket.jacket_type = params[:jacket][:jacket_type].chomp #set jacket type to that input
      end

      # if theres something entered for the brand
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

      # protects my database from bad data
      if @jacket.attributes_filled? #if location, brand and type are filled
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
    if logged_in?
      @user = current_user
      @jacket = Jacket.find_by_slug(params[:jacket_slug])
      erb :'jackets/show'
    else
      redirect "/login"
    end
  end

  get '/:user_slug/jackets/:jacket_slug/edit' do
    if !logged_in?
      redirect "/login"
    else
      @user = current_user
      # for some reason when i move a jacket the location gets deleted
      # binding.pry
      @locations = @user.locations

      # @locations.compact!

      @jacket = Jacket.find_by_slug(params[:jacket_slug])

      erb :'jackets/edit'
    end
  end

  patch '/jackets/:jacket_slug' do  #updates a jacket

    @user = current_user

    @jacket = Jacket.find_by_slug(params[:jacket_slug])
    @jacket.user = @user
    # takes info from text input or falls back on radio boxes

    if params[:jacket][:new_location] && !params[:jacket][:new_location].empty? #if the text box has content
      @location = Location.find_or_create_by(name: params[:jacket][:new_location].chomp)
      # binding.pry
      @jacket.location = @location #overwrite jackets location
      # @user.locations << @location
    elsif params[:jacket][:location_id] && !!params[:jacket][:location_id] #if a location box is ticked -
      @location = Location.find_by(id: params[:jacket][:location_id])
      @jacket.location = @location #find the location by id and set the association
    end

    @location.jackets << @jacket
    @location.save
    @jacket.save

    erb :'jackets/show'
  end


  delete '/jackets/:id/delete' do
    @jacket = Jacket.find_by_id(params[:id])
    if logged_in? && current_user.jackets.include?(@jacket)
        @jacket.delete
        redirect to ':user_slug/jackets'
    else
      redirect to ("/login")
    end
  end


end
