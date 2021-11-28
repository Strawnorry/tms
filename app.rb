require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'

enable :sessions

helpers do
 def current_user
    User.find_by(id: session[:user])
  end
end

get '/' do
  erb :index
end

get '/sign_up' do
  erb :sign_up
end

post '/signup' do
  user = User.create(
    name: params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation],
    tms_url: params[:tms])
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/'
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end