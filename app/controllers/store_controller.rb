class StoreController < ApplicationController
  def index
  	@products = Product.order(:title)
  	@visit_count = increment_visit_count
  end

  private 
  	def increment_visit_count
  		session[:counter] = 0 if session[:counter].nil?
  		session[:counter] += 1
  	end
end