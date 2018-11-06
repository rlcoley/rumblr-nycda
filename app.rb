require 'sinatra'
require 'sinatra/activerecord'
set :database, 'sqlite3:rumblrDB.sqlite3'
require './models'
require 'sinatra/flash'
set :sessions, true

def current_user
  if (session[:user_id])
    @user = User.find(session[:user_id])
  end
end


get "/" do

  erb :index
end


get "/user" do
  @user = User.all
  erb :user
end


get "/user/:id" do
  @user = User.find(params[:id])
  erb :user
end

post "/signup" do
    fname = params[:fname]
    lanme = params[:lanme]
    email = params[:email]
    usersname = params[:usersname]
    password = params[:password]
    User.create(usersname: usersname, password: password, email: email, fname: fname, lanme: lanme)
    redirect "/allblogs"
    flash[:notice] = "New account made!"

end

post "/login" do
  user = User.where(usersname: params[:usersname]).first
  if user.password == params[:password]
    session[:user_id] = user.id
    redirect "/user/#{user.id}"
  else
    erb :index
  end
end

get "/myblogs" do
  @myblogs = Blog.where(user_id: session[:user_id])
  erb :myblogs
end

get "/profile" do
  current_user
  erb :profile
end


post "/create_blog" do
  if session[:user_id]
    title = params[:title]
    content = params[:content]
    user = User.find(session[:user_id])

    Blog.create(title: title, content: content, user_id: user.id)

    redirect "/allblogs"
  else
    redirect "/"
  end
end

get "/allblogs" do
  @blogs = Blog.all
  erb :allblogs
end


get "/selectuser/:id" do
  @user = User.find(params[:id])
  erb :selectuser
end


get "/makepost" do

  erb :makepost
end


get "/logout" do
  session[:user_id] = nil
  erb :index
end


# get "/home" do
#   @user = User.where(usersname: params[:usersname]).first
#   # redirect "/user/#{user.id}"
#   erb :user
# end


get "/deleteaccount" do
  session[:user_id] = User.destroy
  erb :index
  flash[:notice] = "Accont deleted!"
end
