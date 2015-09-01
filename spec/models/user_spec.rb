require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:queue_items).order('position') }

  describe "#queued_video?" do
    it "returns true if the user has the video queued" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_truthy
    end
    it "returns false if the user does not have the video queued" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be_falsey
    end
  end
end