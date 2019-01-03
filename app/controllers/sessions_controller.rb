# class SessionsController < ApplicationController
#
#   get '/login' do
#     erb :"sessions/login.html"
#   end
#
#   post '/sessions' do
#     binding.pry
#     # @user = User.find_by(username: params[:username], password: params[:password])
#     login(params[:username], params[:password])
#     redirect '/jackets'
#   end
#
#   get '/logout' do
#     logout!
#     redirect '/login'
#   end
#
# end
