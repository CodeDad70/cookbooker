class UsersController < ApplicationController

	get "/users/signup" do
		if !logged_in? 
			erb :"/users/create_user"
		else 
			redirect to "/recipes"
		end
	end

	post "/create_user" do
		if params[:username] == "" || params[:password] == ""
			erb :"/users/create_user"
		else 
			@user = User.create(username: params[:username], password: params[:password])
			@user.save		
			session[:user_id] = @user.id		
			erb :"/recipes/index"
		end
	end

	get '/users/login' do 
    if !logged_in?
      erb :'/users/login'
    else
      redirect to "/recipes/index"
    end
  end

  
	

end
