require 'spec_helper'

describe ClaimIdentityKey do

  context 'associations' do
    it { should belong_to :user }
  end

  context 'validations' do
    it { should validate_presence_of :user }
  end

  context 'initialization' do
    before :each do
      user = FactoryGirl.create(:user)
      github_user = FactoryGirl.create(:github_user)
      @claim_identity_key = ClaimIdentityKey.create(user_id: user.id, github_user_id: github_user.id)
    end
    it 'creates a readonly key automatically' do
      @claim_identity_key.key.should_not be_nil
    end

    it 'should not be expired if saved_at is nil' do
      @claim_identity_key.expired?.should be_false
    end

    it 'expires after two hours' do
      @claim_identity_key.created_at = Time.zone.now - (2.hours + 1.second)
      @claim_identity_key.expired?.should be_true
    end

    it 'is not expired if less than two hours have passed' do
      @claim_identity_key.created_at = Time.zone.now - (1.hour + 59.minutes + 1.second)
      @claim_identity_key.expired?.should be_false
    end
  end

  it "associates it's user with it's github user" do
    gh_user = FactoryGirl.create(:github_user)
    user = FactoryGirl.create(:user)
    key = FactoryGirl.create(:claim_identity_key, user: user, github_user: gh_user)

    gh_user.user.should be_nil
    gh_user = key.associate_accounts!
    gh_user.user.should eq(user)
  end

end
