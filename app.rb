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
  unless current_user == nil then
    session = GoogleDrive::Session.from_config("config.json")
    sp = session.spreadsheet_by_url(current_user.tms_url)
    ws = sp.worksheet_by_title(current_user.tms_title)
    @percent = ws[1, 5]
    @purpose = ws[3, 4]
    @image_name = (@percent.to_i / 10).to_s
  end
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

get '/signout' do
  session[:user] = nil
  redirect '/'
end