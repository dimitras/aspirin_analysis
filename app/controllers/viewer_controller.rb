class ViewerController < ApplicationController
	def show
    render params[:page]
	end
end
