class SessionsController < ApplicationController
  skip_before_action :authorize
  before_action :create_user_if_db_is_clean, only: :create

  def new
  end

  def create
  	user = User.find_by(name: params[:name])
  	if user and user.authenticate(params[:password])
  		session[:user_id] = user.id
  		redirect_to admin_url
  	else
  		redirect_to login_url, alert: "Invalid user/password combination"
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to store_url, notice: "Logged out"
  end

  private
    def create_user_if_db_is_clean
      if User.count.zero?
        User.create(:name => params[:name],
                    :password => params[:password],
                    :password_confirmation => params[:password])
      end
    end
end
