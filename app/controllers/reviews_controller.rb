class ReviewsController < ApplicationController

	def new
		@restaurant = Restaurant.find(params[:restaurant_id])
		@review = Review.new
	end

	def create
		@restaurant = Restaurant.find(params[:restaurant_id])
		@restaurant.reviews.create(review_params)
		redirect_to restaurants_path
		# @review = @restaurant.reviews.create(review_params)
		# if @review.save
		# 	redirect_to restaurants_path
		# else 
		# 	render 'new'
		# end 
	end

	def review_params
		params.require(:review).permit(:thoughts, :rating)
	end
end
