class SearchController < ApplicationController
	before_action :authenticate_user!

	def search
		@option = params[:option]
		@choice = params[:choice]
		if @option == 'User'
			@users = User.search(params[:search], @option, @choice)
		elsif @option == 'Book'
			@books = Book.search(params[:search], @option, @choice)
		else
			render 'search'
		end
	end
end
