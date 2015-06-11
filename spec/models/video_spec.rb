require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end

describe 'search_by_title' do
  it "returns an empty array if the search term is an empty string" do
    futurama = Video.create(title: "Futurama", description: "Cartoon about space travel")
    back_to_future = Video.create(title: "Back to future", description: "Movie about space travel")
    expect(Video.search_by_title("")).to eq([])
  end
  it "returns an empty array if there are no matches" do
    futurama = Video.create(title: "Futurama", description: "Cartoon about space travel")
    back_to_future = Video.create(title: "Back to future", description: "Movie about space travel")
    expect(Video.search_by_title("family")).to eq([])
  end
  it "returns an array of one video when there is an exact match" do
    futurama = Video.create(title: "Futurama", description: "Cartoon about space travel")
    back_to_future = Video.create(title: "Back to future", description: "Movie about space travel")
    expect(Video.search_by_title("Futurama")).to eq([futurama])
  end
  it "returns an array of one video when there is an exact match with different case" do
    futurama = Video.create(title: "Futurama", description: "Cartoon about space travel")
    back_to_future = Video.create(title: "Back to future", description: "Movie about space travel")
    expect(Video.search_by_title("fuTurama")).to eq([futurama])
  end
  it "returns an array of one video when there is a partial match" do
    futurama = Video.create(title: "Futurama", description: "Cartoon about space travel")
    back_to_future = Video.create(title: "Back to future", description: "Movie about space travel")
    expect(Video.search_by_title("futur")).to eq([back_to_future, futurama])
  end
  it "returns an array of all matches ordered by created_at" do
    futurama = Video.create(title: "Futurama", description: "Cartoon about space travel")
    back_to_future = Video.create(title: "Back to future", description: "Movie about space travel", created_at: 1.day.ago)
    expect(Video.search_by_title("futur")).to eq([futurama, back_to_future])
  end
end