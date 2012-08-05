require 'spec_helper'

describe GithubUser do
  context 'factory' do
    subject { FactoryGirl.build(:github_user) }
    it { should be_valid }
  end

  context 'associations' do
    it { should belong_to :user }
  end
  context 'mass_assignment' do
    it { should allow_mass_assignment_of :uid }
    it { should allow_mass_assignment_of :email }
    it { should allow_mass_assignment_of :login }
    it { should allow_mass_assignment_of :user_id }
  end

  context 'request identity' do
    before :each do
      @gh_user = FactoryGirl.create(:github_user)
      @user = FactoryGirl.create(:user)
    end
    it 'does nothing if there is no user found' do
      @gh_user.request_identity('foo').should be_nil
    end

    it 'does nothing if it already has a user' do
      @gh_user.update_attributes(user_id: @user.id)
      @gh_user.request_identity(@user.handle).should be_nil
    end

    it 'returns a claim_identity_key if the user handle is valid and there is no user associated' do
      @gh_user.request_identity(@user.handle).is_a?(ClaimIdentityKey).should be_true
    end
  end
  context 'confirm identity' do
    before :each do
      @gh_user = FactoryGirl.create(:github_user)
      @user = FactoryGirl.create(:user)
      @claim_identity_key = FactoryGirl.create(:claim_identity_key, user: @user, github_user: @gh_user)
    end

    it 'does nothing if the key provided does not exist' do
      GithubUser.confirm_identity('bogus_key').should be_nil
    end

    it 'deletes the identity key and returns nothing if the key is expired' do
      @claim_identity_key.created_at = Time.zone.now - 3.hours
      GithubUser.confirm_identity(@claim_identity_key.key)
      expect { ClaimIdentityKey.find(@claim_identity_key.id) }.should raise_error
    end

    it 'associates the accounts and deletes the identity key if the key is not expired' do
      GithubUser.confirm_identity(@claim_identity_key.key)
      GithubUser.find(@gh_user.id).user.should eq(@user)
      User.find(@user.id).github_user.should eq(@gh_user)
      expect { ClaimIdentityKey.find(@claim_identity_key.id) }.should raise_error
    end
  end
  context 'authentication' do
    before :each do
      gh_user = FactoryGirl.build(:github_user)
      OmniAuth.config.add_mock(:github, { provider: :github,
                                 uid: gh_user.uid,
                                 email: gh_user.email,
                                 extra: { 'raw_info' => {email: gh_user.email, login: gh_user.login } } })
      @data = OmniAuth.config.mock_auth[:github]
    end

    it 'creates a new github user' do
      GithubUser.authenticate(@data)
      GithubUser.find_by_email(@data['email']).is_a?(GithubUser).should be_true
    end

    it 'loads existing users' do
      GithubUser.authenticate(@data)
      GithubUser.authenticate(@data)
      GithubUser.all.size.should eq(1)
    end
  end
end
