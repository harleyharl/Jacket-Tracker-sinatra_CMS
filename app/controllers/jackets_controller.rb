class JacketsController < ApplicationController

  get '/jackets/index.erb' do
    binding.pry
    @jackets = Jacket.all
  end

end
