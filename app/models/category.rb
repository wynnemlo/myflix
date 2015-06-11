class Category < ActiveRecord::Base
  has_many :videos, -> { order("title") }

  def recent_videos
    self.videos.reorder("created_at DESC").limit(6)
  end

end
