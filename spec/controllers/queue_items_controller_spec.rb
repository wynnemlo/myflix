require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end 
    it "redirects to the sign in page for unauthorized users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    context "authenticated users" do
      let(:user) {Fabricate(:user)}
      before do
        session[:user_id] = user.id
      end
      it "redirects to the my queue page" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path 
      end
      it "creates a queue item" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "creates the queue item that is associated with the video" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates the queue item that is associated with the signed in user" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(user)
      end
      it "puts the video as the last one in the queue" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: user, position: 1)
        post :create, video_id: video2.id
        queue_item2 = QueueItem.where(video_id: video2.id, user_id: user.id).first
        expect(queue_item2.position).to eq(2)
      end
      it "does not add the video to the queue if the video is already in the queue" do
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video, user: user, position: 1)
        post :create, video_id: video.id
        expect(user.queue_items.count).to eq(1)
      end
    end

    context "unauthenticated users" do
      it "redirects to the sign in page" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to sign_in_path        
      end
    end
  end 


  describe "DELETE destroy" do
    context "authenticated users" do
      let(:user) {Fabricate(:user)}
      before do
        session[:user_id] = user.id
      end
      it "redirects to the my queue page" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      it "deletes the queue item" do
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(user.queue_items.count).to eq(0)
      end
      it "does not delete the queue item if the current user does not own the queue item" do
        alice = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: alice)
        delete :destroy, id: queue_item.id
        expect(alice.queue_items.count).to eq(1)
      end
    end

    context "unauthenticated users" do
      it "redirects to the sign in page" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to sign_in_path    
      end 
    end
  end
end