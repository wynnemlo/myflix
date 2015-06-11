require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
end

describe 'recent_videos' do
  it "should return an empty array if there are no videos in that category" do
    comedy = Category.create(name: "Comedy")
    expect(comedy.recent_videos).to eq([])
  end
  it "should return all the videos in a category if there are less than 6 videos" do
    comedy = Category.create(name: "Comedy")
    futurama = Video.create(title: "Futurama", description: "Space travel cartoon", category: comedy)
    south_park = Video.create(title: "South Park", description: "4 kids", category: comedy)
    family_guy = Video.create(title: "Family Guy", description: "American Family", category: comedy)
    monk = Video.create(title: "Monk", description: "Best drama show", category: comedy)
    expect(comedy.recent_videos).to eq([futurama, south_park, family_guy, monk])
  end
  it "should return the 6 most recent videos in a category if there are more than 6 videos"
  it "should return the 6 most recent videos in a category if there are more than 6 videos in reverse chronological order"
end