require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)). to eq(video)
    end

    it "sets @reviews for authenticated uers" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, user: Fabricate(:user), video: video)
      review2 = Fabricate(:review, user: Fabricate(:user), video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "sets @review as a new empty review" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)     
      get :show, id: video.id
      expect(assigns(:review)).to be_new_record
      expect(assigns(:review)).to be_an_instance_of(Review)
    end

    it "redirects to sign in path for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do
    it "sets @videos for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: "Futurama")
      family_guy = Fabricate(:video, title: "Family Guy")
      get :search, q: "futur"
      expect(assigns(:videos)).to eq([futurama])
    end
    it "redirects to sign in path for unauthenticated users" do
      futurama = Fabricate(:video, title: "Futurama")
      family_guy = Fabricate(:video, title: "Family Guy")
      get :search, q: "futur"
      expect(response).to redirect_to sign_in_path
    end
  end

end