require 'spec_helper'

feature 'User interacts with social network' do
  scenario 'user follows and unfollows another user' do

    bob = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, title: "Monk", category: category)
    review = Fabricate(:review, video: video, user: bob) 

    sign_in
    click_on_video_on_home_page(video)
 
    click_link bob.full_name
    click_link "Follow"
    expect(page).to have_content("People I Follow")
    expect(page).to have_content(bob.full_name)

    unfollow(bob)
    expect(page).not_to have_content(bob.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end