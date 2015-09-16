class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      flash["success"] = "A new video has been added."
      redirect_to new_admin_video_path
    else
      flash["danger"] = "An error has occured. Your video was not uploaded."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover)
  end
end