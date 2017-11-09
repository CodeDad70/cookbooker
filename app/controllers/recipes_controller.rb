class RecipesController < ApplicationController

  # GET: /recipes
  
  get '/recipes' do
  	if logged_in?     
   	 erb :'/recipes/index'
  	else
  		redirect to "/users/login"
  	end
  end

  
end
