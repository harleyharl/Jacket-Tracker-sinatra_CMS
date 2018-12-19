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
    # binding.pry
    @jacket = Jacket.create

    if !params[:jacket][:jacket_type].empty? #if theres something in the jacket type hash
      @jacket.jacket_type = params[:jacket][:jacket_type] #set jacket type to that input
    end

    @jacket.location_id = params[:jacket][:location] #checkbox
    @jacket.location_id = params[:jacket][:new_location] # Or create new location
    # @jacket.brand = params[:jacket][:brand]
    @jacket.save
    @jackets = Jacket.all
    erb :'/jackets/index'

  end

end
