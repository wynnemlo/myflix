require 'spec_helper'

feature 'User interacts with queue' do
  scenario "user adds and reorders videos in the queue" do

    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)

    sign_in
    add_video_to_queue(monk)
    page.should have_content(monk.title)

    visit video_path(monk)
    page.should_not have_content("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    fill_in "video_#{monk.id}", with: 3
    fill_in "video_#{south_park.id}", with: 1
    fill_in "video_#{futurama.id}", with: 2

    click_button "Update Instant Queue"

    expect_video_position(south_park, "1")
    expect_video_position(futurama, "2")
    expect_video_position(monk, "3")
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def expect_video_position(video, position)
    expect(find("#video_#{video.id}").value).to eq(position)
  end
end