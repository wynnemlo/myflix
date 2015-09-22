require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: "password", full_name: "Bobby Chan" )).sign_up("some_stripe_token", invitation.token)
        bob = User.where(email: 'bob@example.com').first
        expect(bob.follows?(alice)).to be_truthy
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: "password", full_name: "Bobby Chan" )).sign_up("some_stripe_token", invitation.token)
        bob = User.where(email: 'bob@example.com').first
        expect(alice.follows?(bob)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: "password", full_name: "Bobby Chan" )).sign_up("some_stripe_token", invitation.token)
        expect(invitation.reload.token).to be_nil
      end

      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
      end

      it "sends out the email containing the user's name with valid input" do
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', full_name: "Bobby Chan")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Bobby Chan')
      end
    end

    context "with valid personal info and declined card" do
      it "does not create the user" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      after { ActionMailer::Base.deliveries.clear }

      it "does not create the user" do
        UserSignup.new(User.new(email: 'bob@example.com')).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignup.new(User.new(email: 'bob@example.com')).sign_up("some_stripe_token", nil)
      end

      it "does not send out email with invalid inputs" do
        UserSignup.new(User.new(email: 'bob@example.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end