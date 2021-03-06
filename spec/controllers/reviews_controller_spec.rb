require 'spec_helper'

describe ReviewsController do

  describe "POST create" do
    let(:video) { Fabricate(:video) }
    
    it_behaves_like "requires sign in" do
      let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to sign_in_path }
    end 
    
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      before { set_current_user(user) }

      context "with valid input" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(user)
        end

        it "should redirect to the video show page" do
          expect(response).to redirect_to video
        end
      end

      context "with invalid input" do
        it "renders the video/show template" do
          post :create, review: { rating: 5 }, video_id: video.id
          expect(response).to render_template "videos/show"
        end
        it "does not create a review" do
          post :create, review: { rating: 5 }, video_id: video.id
          expect(Review.count).to eq(0)
        end
        it "sets @video" do
          post :create, review: { rating: 5 }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end
        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: { rating: 5 }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

  end

end