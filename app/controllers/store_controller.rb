class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def index
    if params[:set_locale]
      redirect_to store_url(locale: params[:set_locale])
    else
  	 @products = Product.all_for_current_locale
    end
  	@visit_count = increment_visit_count
  end

  private 
  	def increment_visit_count
  		session[:counter] = 0 if session[:counter].nil?
  		session[:counter] += 1
  	end
end
