class AuthController < ApplicationController
  layout 'auth'
  
  # Manages the authentification process with the login page
  def login
		# If the person is already logged in, redirected to the index
    redirect_to(:controller=>"neurons", :action=>"index") unless session[:user_id].nil? 
	
		  if request.post?
			  user = User.authenticate(params[:name], params[:password])
			  if user
          session[:user_id]=user.id          
				  redirect_to(:controller=>"neurons", :action=>"index")
			  else
				  flash.now[:error] = "Wrong password"
			  end
		  end
	end

	# Manages the logout process
  def logout
    session[:user_id]=nil    
		redirect_to(:controller=>"neurons", :action=>"index")
  end
  
end
