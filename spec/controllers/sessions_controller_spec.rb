require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "should redirect to home_path for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
    
    it "should render the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    let(:alice) {Fabricate(:user)}

    context "with valid credentials" do
      before do
        post :create, email: alice.email, password: alice.password
      end

      it "puts the signed in user in the session" do
        expect(session[:user_id]).to eq(alice.id)
      end
      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end
      it "sets the notice" do   
        expect(flash["success"]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      before do
        post :create, email: alice.email, password: 'something'
      end

      it "does not put the signed in user in the session" do
        expect(session[:user_id]).to be_nil
      end   

      it "should redirect to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets the error message" do
        expect(flash["danger"]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "should empty the session's user_id" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      expect(response).to redirect_to root_path
    end

    it "sets the notice" do
      expect(flash["success"]).not_to be_blank
    end
  end
end