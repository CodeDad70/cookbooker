class RecipesController < ApplicationController

  # GET: /recipes
  
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
  		redirect to "/users/login"
  	end
  end

 

  
end
