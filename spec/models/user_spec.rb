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

  context 'class methods' do

    before :each do
      @user = FactoryGirl.create(:user, rank: 4, total_downloads: 100)
      FactoryGirl.create(:user, rank: 1, total_downloads: 1)
    end

    it "returns the page for the user based on ranking and assumes that ranking will never be sparse" do
      User.find_page_by_handle(@user.handle, 2).should be(2)
    end

    it "refreshes the ranking" do
      User.refresh_rank
      User.find(@user.id).rank.should eq(1)
    end
  end
end
