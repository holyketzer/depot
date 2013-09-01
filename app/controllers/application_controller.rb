class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize

  protected
  	def authorize    
      unless request.format == Mime::HTML
        authenticate_or_request_with_http_basic do |name,password|
          user = User.find_by_name(name)
          session[:user_id] = user.id if user && user.authenticate(password)
        end  
      else
    		unless User.find_by(id: session[:user_id])
  			  redirect_to login_url, notice: "Please log in"  		
        end
      end
  	end
end
