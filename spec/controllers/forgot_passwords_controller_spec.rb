require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }

    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to(forgot_password_path)
      end

      it "shows an error message" do
        post :create, email: ''
        expect(flash["danger"]).to eq("Email cannot be blank.")
      end
    end

    context "with existing email" do
      it "redirects to the confirmation page" do
        alice = Fabricate(:user, email: 'alice@example.com')
        post :create, email: alice.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends an email to the user's email" do
        alice = Fabricate(:user, email: 'alice@example.com')
        post :create, email: alice.email
        expect(ActionMailer::Base.deliveries.last.to).to eq(['alice@example.com'])     
      end

      it "sets the user's token to a random token" do
        alice = Fabricate(:user, email: 'alice@example.com')
        post :create, email: alice.email
        expect(alice.reload.token).not_to be_nil
      end

      it "sends an email containing a URL with a random token" do
        alice = Fabricate(:user, email: 'alice@example.com')
        post :create, email: alice.email
        expect(ActionMailer::Base.deliveries.last.body).to include(alice.token)
      end

    end

    context "with non-existing email" do
      it "redirects to the forgot_password page" do
        alice = Fabricate(:user, email: 'alice@example.com')
        post :create, email: 'bob@example.com'
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        alice = Fabricate(:user, email: 'alice@example.com')
        post :create, email: 'bob@example.com'
        expect(flash["danger"]).to eq("There is no user with that email in the system.")
      end

      it "does not send out an email" do
        alice = Fabricate(:user, email: 'alice@example.com')
        post :create, email: 'bob@example.com'
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end