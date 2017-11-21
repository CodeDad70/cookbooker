require 'sinatra/base'
require 'rack-flash'

class UsersController < ApplicationController

  use Rack::Flash

  get "/users/signup" do
    if !logged_in? 
      erb :"/users/create_user"
    else 
      redirect to "/recipes/user_index"
    end
  end

  post "/create_user" do
    if params[:username] == "" || params[:password] == "" 
      flash[:message] = "Please fill out all fields"
      erb :"/users/create_user"

    elsif User.exists?(username: params[:username])
      flash[:message] = "Username is taken - please try a different one."
      erb :"/users/create_user"
    else 
      @user = User.new(username: params[:username], password: params[:password])
      @user.save    
      session[:user_id] = @user.id    
      erb :"/recipes/welcome"
    end
  end

  get '/users/login' do 
    if !logged_in?
      erb :'/users/login'
    else
      redirect to "/recipes/user_index"
    end
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/recipes/user_index"
    else 
      flash[:message] = "Login or Password is incorrect - please try again"
      erb :"/users/login"
    end
  end

  get '/users/logout' do
    if logged_in?
      session.destroy
      redirect to '/users/login'
    else
      redirect to '/'
    end
  end

end