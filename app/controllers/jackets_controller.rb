class JacketsController < ApplicationController

  get '/jackets' do
    # binding.pry
    @jackets = Jacket.all
    erb :'/jackets/index'
  end

  get '/jackets/new' do

    @locations = Location.all
    @brands = Brand.all

    @jacket_types = Jacket.all.collect do |jacket|
      jacket.jacket_type
    end

    erb :'/jackets/new'

  end

  post '/jackets' do

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
    # binding.pry
    if params[:jacket][:location_id] && !!params[:jacket][:location_id] #if a location box is ticked -
      @location = Location.find_by(id: params[:jacket][:location_id])
      @jacket.location = @location #find the location by id and set the association
      @location.jackets << @jacket
    end
    #or we overwrite with whats in text box
    # if !params[:jacket][:new_location].empty? #if the text box has content
    #   @jacket.location = Location.create(name: params[:jacket][:new_location]) #overwrite jackets location
    # end
    # binding.pry
    if params[:jacket][:new_location] && !params[:jacket][:new_location].empty? #if the text box has content
      @location = Location.create(name: params[:jacket][:new_location])
      @jacket.location = @location #overwrite jackets location
      @location.jackets << @jacket
    end


    @jacket.save
    @location.save

    @jackets = Jacket.all #WHY DO I HAVE TO DO THIS HERE

    erb :'/jackets/index'

  end


  get '/jackets/:id' do
    @jacket = Jacket.find_by(id: params[:id])
    erb :'jackets/show'
  end

end
