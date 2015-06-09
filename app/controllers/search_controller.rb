class SearchController < ApplicationController
	authorize_resource

	respond_to :html

	def search
		@search_results = Search.search(params[:search][:query], params[:filter])
		respond_with(@search_results)
	end
end
