require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets the @video variable" do
      family_guy = Video.create(title: "Family Guy", description: "A funny cartoon")
      get :show, id: family_guy.id
      assigns(:video).should == family_guy
    end
    it "renders the show template" do
      family_guy = Video.create(title: "Family Guy", description: "A funny cartoon")
      get :show, {id: 1}
      response.should render_template :show
    end
  end
  describe "GET search" do
    it "sets the @videos variable"
    it "renders the search template"
  end
end