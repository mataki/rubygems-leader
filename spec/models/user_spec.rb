require 'spec_helper'

describe User do
  context 'factory' do 
    subject { FactoryGirl.build :user }
    it { should be_valid }
  end

  context 'validations' do
    it { should validate_presence_of :handle }
    it { should validate_presence_of :email }
    it { should validate_presence_of :profile_id }
    it { FactoryGirl.create(:user)
         should validate_uniqueness_of(:profile_id) }
  end

  context 'mass assignment' do
    it { should allow_mass_assignment_of :handle }
    it { should allow_mass_assignment_of :email }
    it { should allow_mass_assignment_of :profile_id }
    it { should allow_mass_assignment_of :total_downloads }
  end
end
