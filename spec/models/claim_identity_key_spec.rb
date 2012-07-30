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
      @claim_identity_key = ClaimIdentityKey.new(user: user)
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
end
