require 'sinatra'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "database.sqlite3"}

class User < ActiveRecord::Base
end


class Post < ActiveRecord::Base
end

get "/" do
  erb :home => false layout
end

# ===== USER ROUTES =====

get "/users/new" do
  erb :"/users/new"
end


post "/users/new" do # CREATE
  @user = User.new(first_name: params['first_name'], last_name: params['last_name'], email: params['email'], birthday: params['birthday'])
  @user.save

  redirect "/users/#{@user.id}"
end

get "/users/:id" do # READ
  @user = User.find(params['id'])

  erb :"/users/show"
end

# ===== POST ROUTES =====

get "/posts/new" do
  erb :"/posts/new"
end

post "/posts/new" do # CREATE
  post = Post.new(title: params['title'], context: params['context'])
  @post.save
  erb :"/posts/new"
end

get "/posts/:id" do
  @post = Post.find(params['id'])

  erb :"/posts/new"
end
