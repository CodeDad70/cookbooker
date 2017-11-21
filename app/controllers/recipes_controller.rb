require 'sinatra/base'
require 'rack-flash'

class RecipesController < ApplicationController

  use Rack::Flash

  #-------view recipes -----------------
  
  get '/recipes' do
    if logged_in?
      redirect to "/recipes/user_index"

      else redirect to "/recipes/community_index" 
    end
  end

  get "/recipes/user_index" do
    @recipe_community = Recipe.all
    if logged_in?  
     erb :"/recipes/user_index"
    else
      redirect to "/users/login"  
    end
  end


  get "/recipes/community_index" do
    @recipes = Recipe.all
    erb :"/recipes/community_index"
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
      current_user.recipes << @recipe
      redirect to "/recipes/#{@recipe.id}"
    end
  end

  #-------------recipe pages----------------

  get '/recipes/:id' do
    @recipe = Recipe.find_by(id: params[:id])
    if logged_in? && current_user.id == @recipe.user_id 
      erb :"/recipes/show"
    else
      erb :"/recipes/view"
    end
  end 


  #--------------edit recipes----------------

  get '/recipes/:id/edit' do
    if logged_in?
      @recipe = Recipe.find_by(id: params[:id])     
      current_user.id == @recipe.user_id
      erb :'/recipes/edit' 
    else
      redirect 'users/login'    
    end
  end

    
  patch '/recipes/:id' do
    if logged_in?
      @recipe = Recipe.find_by_id(params[:id])
      @recipe.update(name: params[:name], ingredients: params[:ingredients], instructions: params[:instructions])
        @recipe.save
        redirect "/recipes/#{@recipe.id}"
    else 
        redirect "/user/login"
    end
  end



   delete '/recipes/:id/delete' do
    if logged_in?
      @recipe = Recipe.find_by_id(params[:id])
      if @recipe.user_id == current_user.id
        @recipe.delete
        redirect to "/recipes/user_index"
      end
    else
      redirect '/login'
    end
  end

  
end