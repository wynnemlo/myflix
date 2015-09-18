require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user as a new empty user" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_an_instance_of(User)
    end
    it "redirects already signed in users to home" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end
    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    it "redirects to expired token page for invalid tokens" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: '12345'
      expect(response).to redirect_to expired_token_path
    end
    it "redirects already signed in users to home" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid personal info and valid credit card" do
      let(:charge) { double(:charge, successful?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to the sign_in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: { email: 'bob@example.com', password: "password", full_name: "Bobby Chan" }, invitation_token: invitation.token
        bob = User.where(email: 'bob@example.com').first
        expect(bob.follows?(alice)).to be_truthy
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: { email: 'bob@example.com', password: "password", full_name: "Bobby Chan" }, invitation_token: invitation.token
        bob = User.where(email: 'bob@example.com').first
        expect(alice.follows?(bob)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: { email: 'bob@example.com', password: "password", full_name: "Bobby Chan" }, invitation_token: invitation.token
        expect(invitation.reload.token).to be_nil
      end
    end

    context "with valid personal info and declined card" do
      it "does not create the user" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123132'
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123132'
        expect(response).to render_template :new
      end
      it "sets the flash error message" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123132'
        expect(flash["danger"]).to be_present
      end
    end

    context "with invalid personal info" do
      before do
        post :create, user: {email: 'me@example.com', full_name: "Wynne Lo"}
      end
      after { ActionMailer::Base.deliveries.clear }

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
      
      it "sets @user" do
        expect(assigns(:user)).to be_an_instance_of(User)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "does not send out email with invalid inputs" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "email sending" do
      let(:charge) { double(:charge, successful?: true) }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: {email: 'me@example.com', password: "password", full_name: "Wynne Lo"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['me@example.com'])
      end

      it "sends out the email containing the user's name with valid input" do
        post :create, user: {email: 'me@example.com', password: "password", full_name: "Wynne Lo"}
        expect(ActionMailer::Base.deliveries.last.body).to include('Wynne Lo')
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user
      user = Fabricate(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end
end