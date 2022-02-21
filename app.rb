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
    sessionGD = GoogleDrive::Session.from_config("config.json")
    sp = sessionGD.spreadsheet_by_url(current_user.tms_url)
    ws = sp.worksheet_by_title(current_user.tms_title)
    @percent = ws[1, 5]
    @percent_number = @percent.slice(/\d+/).to_i
    @present_persent = History.find_by(user_id: current_user.id) 
    @purpose = ws[3, 4]
    @image_name = (@percent_number/10).to_s
    if @percent_number >= 99.0
      current_user.update(test: 't')
    end
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

get '/edit' do
  erb :edit
end

post '/make_history/:percent' do
  History.create(
    user: current_user,
    rate: params[:percent]
    )
  redirect '/'
end