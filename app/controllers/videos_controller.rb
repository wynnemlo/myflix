class VideosController < ApplicationController
  before_action :require_user

  def index
    if user_signed_in?
      @categories = Category.all
    else
      redirect_to root_path
    end
  end

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:q])
  end
end