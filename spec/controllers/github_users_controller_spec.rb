require 'spec_helper'

describe GithubUsersController do
  context 'with an oauthed github user' do
    before do
      #ActionView::Template.default_url_options[:host] = 'example.com'
      @gh_user = FactoryGirl.create(:github_user)
      session[:github_user_id] = @gh_user.id
    end

    it 'renders the show form' do
      get :show, id: @gh_user.id
      assigns(:github_user).should eq(@gh_user)
    end
    
    it 'only allows access to your own github show page' do
      get :show, id: 13
      flash[:alert].should be
      response.should redirect_to(root_path)
    end
    
    it 'emails identity requests' do
      user = FactoryGirl.create(:user)
      get :request_identity, github_user_id: @gh_user.id, user_handle: user.handle
      assigns(:success).should be_true
      response.should render_template(partial: "github_users/_request_identity", layout: false)
    end
  end

  context 'without an oauthed github user' do
    before do
      @gh_user = FactoryGirl.create(:github_user)
      user = FactoryGirl.create(:user)
      @claim_key = FactoryGirl.create(:claim_identity_key, github_user_id: @gh_user.id, user_id: user.id)
    end
    it 'confirms indentites' do
      get :confirm_identity, key: @claim_key.key, github_user_id: @gh_user.id
      flash[:notice].should_not be_empty
      response.should redirect_to(root_path)

    end
  end
end
