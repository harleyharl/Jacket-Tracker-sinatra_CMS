require_relative '../models/concerns/slugifiable.rb'

class JacketsController < ApplicationController

  include Slugifiable #so we can use as instance method
  extend Slugifiable #so we can use as class method for methods like Artist.find_by_slug


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
      @jacket.jacket_type = params[:jacket][:jacket_type].chomp #set jacket type to that input
    end
    #or set jacket type with whats in the box
    if params[:jacket][:new_jacket_type] && !params[:jacket][:new_jacket_type].empty?
      @jacket.jacket_type = params[:jacket][:new_jacket_type].chomp
    end

    if params[:jacket][:brand] && !params[:jacket][:brand].empty?
      @jacket.brand = Brand.find_or_create_by(name: params[:jacket][:brand].chomp)
    end

    #takes info from location radio boxes
    if params[:jacket][:location_id] && !!params[:jacket][:location_id] #if a location box is ticked -
      @location = Location.find_by_id(params[:jacket][:location_id])
      @jacket.location = @location #find the location by id and set the association
      @location.jackets << @jacket
    end

    if params[:jacket][:new_location] && !params[:jacket][:new_location].empty? #if the text box has content
      @location = Location.create(name: params[:jacket][:new_location].chomp)
      @jacket.location = @location #overwrite jackets location
      @location.jackets << @jacket
    end

    @user.jackets << @jacket
    @user.save
    @location.save

    redirect "/#{user_slug}/jackets"
    end

  end


  get '/:user_slug/jackets/:jacket_slug' do

    @user = User.find_by_slug(params[:user_slug])
    @jacket = Jacket.find_by_slug(params[:jacket_slug])
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
