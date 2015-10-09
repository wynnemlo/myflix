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

  def advanced_search
    options = {
      reviews: params[:reviews],
      rating_from: params[:rating_from],
      rating_to: params[:rating_to]
    }
    if params[:query]
      @videos = Video.search(params[:query], options).records.to_a
    end
  end
end