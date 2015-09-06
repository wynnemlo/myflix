require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user as a new empty user" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_an_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign_in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid input" do
      before do
        post :create, user: {email: 'me@example.com', full_name: "Wynne Lo"}
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
      
      it "sets @user" do
        expect(assigns(:user)).to be_an_instance_of(User)
      end
    end

    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: {email: 'me@example.com', password: "password", full_name: "Wynne Lo"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['me@example.com'])
      end

      it "sends out the email containing the user's name with valid input" do
        post :create, user: {email: 'me@example.com', password: "password", full_name: "Wynne Lo"}
        expect(ActionMailer::Base.deliveries.last.body).to include('Wynne Lo')
      end

      it "does not send out email with invalid inputs" do
        post :create, user: {email: 'me@example.com'}
        expect(ActionMailer::Base.deliveries).to be_empty
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