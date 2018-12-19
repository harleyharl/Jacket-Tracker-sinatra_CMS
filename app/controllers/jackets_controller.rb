class JacketsController < ApplicationController

  get '/jackets' do
    @jackets = Jacket.all
    erb :'/jackets/index'
  end

  get '/jackets/new' do

    @locations = Location.all
    @brands = Brand.all

    @jacket_types = Jacket.all.collect do |jacket|
      # binding.pry
      jacket.jacket_type
    end

    erb :'/jackets/new'

  end

  post '/jackets' do
    # binding.pry
    @jacket = Jacket.create
    @jacket.jacket_type = params[:jacket][:jacket_type] #checkbox
    @jacket.location_id = params[:jacket][:location] #checkbox
    @jacket.location_id = params[:jacket][:new_location] # Or create new location
    # @jacket.brand = params[:jacket][:brand]
    @jacket.save
    erb :'/jackets/index'

  end

end
