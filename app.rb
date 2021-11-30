require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'google_drive'

enable :sessions

helpers do
 def current_user
    User.find_by(id: session[:user])
  end
end

get '/' do
  sp = session.spreadsheet_by_url(current_user.tms_url)
  ws = sp.worksheet_by_title(current_user.tms_title)
  @percent = ws[1, 5]
  
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
    tms_url: params[:tms_url],
    tms_title: params[:tms_title])
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