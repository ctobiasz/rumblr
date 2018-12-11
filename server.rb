require 'sinatra'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "database.sqlite3"}

class User < ActiveRecord::Base
end


class Post < ActiveRecord::Base
end

get "/" do
  erb :home
end

get "/users/new" do
  erb :"/users/new"
end

post "/users/new" do # CREATE
  user = User.new(first_name: params['first_name'], last_name: params['last_name'], email: params['email'], birthday: params['birthday'])
  erb :"/users/new"
end

get "/posts/new" do
  erb :"/posts/new"
end

post "/posts/new" do # CREATE
  erb :"/posts/new"
end
