class Category < ActiveRecord::Base
  has_many :videos, -> { order("title") }

  def recent_videos
    return [] if self.videos.blank?
    self.videos.limit(6).order("created_at DESC")
  end

end