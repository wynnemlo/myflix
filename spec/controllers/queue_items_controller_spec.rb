require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do

    it "sets @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end 

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    context "authenticated users" do
      let(:alice) { Fabricate(:user) }
      before { set_current_user(alice) }

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
        expect(QueueItem.first.user).to eq(alice)
      end

      it "puts the video as the last one in the queue" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: alice, position: 1)
        post :create, video_id: video2.id
        queue_item2 = QueueItem.where(video_id: video2.id, user_id: alice.id).first
        expect(queue_item2.position).to eq(2)
      end

      it "does not add the video to the queue if the video is already in the queue" do
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video, user: alice, position: 1)
        post :create, video_id: video.id
        expect(alice.queue_items.count).to eq(1)
      end

    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, video_id: 2 }
    end

  end 


  describe "DELETE destroy" do
    context "authenticated users" do

      let(:alice) {Fabricate(:user)}
      before do
        set_current_user(alice)
      end

      it "redirects to the my queue page" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item" do
        queue_item = Fabricate(:queue_item, user: alice)
        delete :destroy, id: queue_item.id
        expect(alice.queue_items.count).to eq(0)
      end

      it "does not delete the queue item if the current user does not own the queue item" do
        bob = Fabricate(:user)
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: bob, video: video)
        delete :destroy, id: queue_item.id
        expect(bob.queue_items.count).to eq(1)
      end

      it "normalizes the remaining queue" do
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        delete :destroy, id: queue_item1
        expect(alice.queue_items.first.position).to eq(1)
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 2 }
    end
  end

  describe "POST update_queue" do

    it_behaves_like "requires sign in" do
      let(:action) { post :update_queue, queue_items: [{id: 3, position: 3.4}, {id: 4, position: 2}] }
    end

    context "with valid inputs" do
      let(:alice) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) {Fabricate(:queue_item, user: alice, position: 1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: alice, position: 2, video: video)}

      before { set_current_user(alice) }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue item" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      let(:alice) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) {Fabricate(:queue_item, user: alice, position: 1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: alice, position: 2, video: video)}
      
      before { set_current_user(alice) }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash["danger"]).to be_present
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        alice = Fabricate(:user)
        set_current_user(alice)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end

end