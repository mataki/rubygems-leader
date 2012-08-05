require 'spec_helper'

describe SessionsController do

  before :each do
    OmniAuth.config.test_mode = true
    @gh_user = FactoryGirl.build(:github_user)
    OmniAuth.config.add_mock(:github, { provider: :github,
                                        uid: @gh_user.uid,
                                        extra: { raw_info: { email: @gh_user.email, login: @gh_user.login } } })
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

  context 'creating new session from omniauth callback' do

    before :each do
     get :create, provider: :github
    end

    it 'sets the github_user_id' do
      session[:github_user_id].should_not be_nil
    end

    it 'redirects to the gethub_user screen when there is no user associated with the github_user' do
      response.should redirect_to(github_user_path(session[:github_user_id]))
    end
  end

  context 'with an existing user/github_user pair' do

    before :each do
      @user = FactoryGirl.create(:user, email: @gh_user.email)
      get :create, provider: :github
    end

    it 'redirects to root after authenticating' do
      response.should redirect_to(root_path)
    end

    it 'sets the user_id session value' do
      session[:user_id].should eq(@user.id)
    end
  end

  describe "auth failure" do
    before do
      OmniAuth.config.test_mode = true
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github] = :invalid_credentials
    end

    it "redirects to root with the failure message" do
      get :auth_failure, message: 'invalid_credentials'
      flash[:alert].should eq('invalid_credentials')
      response.should redirect_to(root_path)
    end
  end
end
