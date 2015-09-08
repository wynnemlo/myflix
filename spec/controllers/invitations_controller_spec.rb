require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid input" do
      let(:alice) { Fabricate(:user) }
      before { set_current_user(alice) }
      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the invitation new page" do
        post :create, invitation: { recipient_name: "Bob", recipient_email: 'bob@gmail.com' }
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        post :create, invitation: { recipient_name: "Bob", recipient_email: 'bob@gmail.com' }
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        post :create, invitation: { recipient_name: "Bob", recipient_email: 'bob@gmail.com' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@gmail.com'])
      end

      it "sets the flash success message" do
        post :create, invitation: { recipient_name: "Bob", recipient_email: 'bob@gmail.com' }
        expect(flash["success"]).to eq("Your invitation has been sent.")
      end
    end

    context "with invalid input" do
    end
  end
end