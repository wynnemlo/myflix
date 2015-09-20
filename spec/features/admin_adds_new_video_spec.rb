require 'spec_helper'

feature 'Admin adds new video' do
  scenario "admin successfully adds a new video" do
    comedy = Fabricate(:category, name: "Comedy")

    alice = Fabricate(:admin)
    sign_in(alice)

    visit new_admin_video_path
    fill_in "Title", with: "Monk"
    select "Comedy", from: "Category"
    fill_in "Description", with: "Awesome show!"
    attach_file 'video_large_cover', "spec/support/uploads/monk_large.jpg"
    attach_file 'video_small_cover', "spec/support/uploads/monk.jpg"
    fill_in "Video url", with: 'https://s3-ap-southeast-1.amazonaws.com/wynnemlo-myflix/free-loops_Bokeh_Lights_12.mp4'
    sleep 10
    click_button "Add Video"

    sign_out
    sign_in

    visit video_path(Video.first)
    sleep 10
    expect(page).to have_selector("img[src='/uploads/video/large_cover/1/monk_large.jpg']")
    expect(page).to have_selector("a[href='https://s3-ap-southeast-1.amazonaws.com/wynnemlo-myflix/free-loops_Bokeh_Lights_12.mp4']")
  end
end