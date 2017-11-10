require 'sinatra/base'
require 'rack-flash'

class RecipesController < ApplicationController

  use Rack::Flash
  
  get '/recipes' do
  	@user = current_user
  	if logged_in?    
   	 erb :'/recipes/index'
  	else
  		redirect to "/users/login"
  	end
  end

  get '/recipes/new' do
  	if logged_in? 
  		erb :'recipes/create_recipe'
  	else
      flash[:message] = "Please Login to create a recipe"
  		erb :"/users/login"
  	end
  end

  post '/recipes' do
    if params[:name] == ""
      flash[:message] = "Please name your recipe"
      erb :"/recipes/create_recipe"
    elsif params[:ingredients] == ""
      flash[:message] = "Please enter your ingredients"
      erb :"/recipes/create_recipe"
    elsif params[:instructions] == ""
      flash[:message] = "Please enter your instructions for cooking the recipe"
      erb :"/recipes/create_recipe"

   else 
      @recipe = Recipe.create(name: params[:name], ingredients: params[:ingredients], instructions: params[:insgstructions])
      @recipe.save
      @user= current_user
      @user.recipes << @recipe
      redirect to "/recipes/#{@recipe.id}"
    end
  end

 

  
end
