require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }
end

describe '#recent_videos' do
  it "should return an empty array if there are no videos in that category" do
    comedy = Category.create(name: "Comedy")
    expect(comedy.recent_videos).to eq([])
  end
  it "should return all the videos in a category if there are less than 6 videos, in reverse chronological order by created_at" do
    comedy = Category.create(name: "Comedy")
    futurama = Video.create(title: "Futurama", description: "Space travel cartoon", category: comedy, created_at: 3.seconds.ago)
    south_park = Video.create(title: "South Park", description: "4 kids", category: comedy, created_at: 10.seconds.ago)
    family_guy = Video.create(title: "Family Guy", description: "American Family", category: comedy, created_at: 1.day.ago)
    monk = Video.create(title: "Monk", description: "Best drama show", category: comedy, created_at: 2.days.ago)
    expect(comedy.recent_videos).to eq([futurama, south_park, family_guy, monk])
  end
  it "should return the 6 most recent videos in a category if there are more than 6 videos, in reverse chronological order by created_at" do
    comedy = Category.create(name: "Comedy")
    futurama = Video.create(title: "Futurama", description: "Space travel cartoon", category: comedy, created_at: 3.seconds.ago)
    south_park = Video.create(title: "South Park", description: "4 kids", category: comedy, created_at: 10.seconds.ago)
    family_guy = Video.create(title: "Family Guy", description: "American Family", category: comedy, created_at: 1.day.ago)
    monk = Video.create(title: "Monk", description: "Best drama show", category: comedy, created_at: 2.days.ago)
    adventure_time = Video.create(title: "Adventure Time", description: "Cartoon", category: comedy, created_at: 3.days.ago)
    daria = Video.create(title: "Daria", description: "High school girl", category: comedy, created_at: 4.days.ago)
    ted = Video.create(title: "Ted", description: "A huge teddy", category: comedy, created_at: 9.days.ago)
    gilmore_girls = Video.create(title: "Gilmore Girls", description: "TV drama show", category: comedy, created_at: 10.days.ago)
    expect(comedy.recent_videos).to eq([futurama, south_park, family_guy, monk, adventure_time, daria])
  end

end