require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'

enable :sessions


if ENV['RACK_ENV']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end


class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end


class Post < ActiveRecord::Base
  belongs_to :user
end

get "/" do
  p session
  @req = request.path
  erb :home
end

# ===== LOGIN ROUTES =====
get "/login" do # READ
  session['user_id'] = nil
  erb :'/users/login'
end

post "/login" do # CREATE
  p params
  user = User.find_by(email: params['email'])
  if user != nil
    if user.password == params['password']
      session[:user_id] = user.id
      redirect "/users/#{user.id}"
    end
  end
end
# ===== USER ROUTES =====

get "/users/new" do
  if session['user.id'] != nil
    p "You are currently logged in"
    redirect "/"
  end
  erb :"/users/new"
end


post "/users/new" do # CREATE
  @user = User.new(first_name: params['first_name'], last_name: params['last_name'], email: params['email'], password: params['password'], birthday: params['birthday'])
  @user.save
  session[:user_id] = @user.id
  redirect "/users/#{@user.id}"
end

get "/users/:id" do # READ
  @user = User.find(params['id'])
  @posts = Post.where(user_id: params['id']).last(20)
  erb :"/users/show"
end

get "/users/?" do
 @users = User.all
 erb :"/users/index"
end

post "/users/:id" do
  @user = User.find(params['id'])
  @user.destroy
  session.clear
  redirect "/"
end



# ===== POST ROUTES =====

get "/posts/new" do
  if session[:user_id] == nil
    p "You're not logged in. Please login or make an account"
    redirect "/"
  end
  erb :"/posts/new"
end

post "/posts/new" do # CREATE
  p "Post has been created"
  @post = Post.new(title: params['title'], content: params['content'], user_id: session['user_id'])
  @post.save
  redirect :"/users/#{session["user_id"]}"
end

get "/posts/:id" do
  @post = Post.find(params['id'])
  erb :"/posts/show"

end

get "/posts/?" do
 @posts = Post.all.reverse
 erb :"/posts/index"
end

post "/posts/:id" do
    @post =  Post.find(params['id'])
    @post.destroy
    redirect :"/users/#{session["user_id"]}"
end

# ===== LOGOUT ROUTES =====
post "/logout" do
  session['user_id'] = nil
  p session
  redirect "/"
end
