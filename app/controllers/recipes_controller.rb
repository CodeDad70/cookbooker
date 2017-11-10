require 'sinatra/base'
require 'rack-flash'

class RecipesController < ApplicationController

  use Rack::Flash

  #-------view recipes -----------------
  
  get '/recipes' do
    @user = current_user
    erb :"/recipes/index"
  end

  get "/recipes/user_index" do
    @user = current_user
    @recipes = @user.recipes
    @recipe_community = Recipe.all

    if logged_in?  
     erb :"/recipes/user_index"
    else
      redirect to "/users/login"  
    end
  end

  #------------------create recipes-----------


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
      @recipe = Recipe.create(name: params[:name], ingredients: params[:ingredients], instructions: params[:instructions])
      @recipe.save
      @user= current_user
      @user.recipes << @recipe
      redirect to "/recipes/#{@recipe.id}"
    end
  end

  #-------------recipe pages----------------

  get '/recipes/:id' do
    @user = current_user
    @recipe = Recipe.find_by(id: params[:id])
   

    if logged_in? && @user.id == @recipe.user_id
      erb :"/recipes/show"
    else
      erb :"/recipes/view"
    end
  end 


  #--------------edit recipes----------------

  get '/recipes/:id/edit' do
    @user = current_user
    @recipe = Recipe.find_by(id: params[:id])
      
      @recipe = Recipe.find_by(id: params[:id])
      if logged_in? && @user.id == @recipe.user_id
        erb :'/recipes/edit'
      else
        redirect 'users/login'    
      end
    end

    patch '/recipes/:id' do
      @recipe = Recipe.find_by_id(params[:id])
    
      if logged_in? && !params["name"].empty?
        @recipe.update(name: params["name"])
        @recipe.save
        redirect "/recipes/#{@recipe.id}"
        
      else
        flash[:message] = "Please fill out all fields"
        erb :"/recipes/edit"
      end
    end

  
end