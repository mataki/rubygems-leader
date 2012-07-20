require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    before do
      @first_user = FactoryGirl.create(:user)
      @second_user = FactoryGirl.create(:user)
    end
    it 'lists users' do
      visit '/users'
      page.should have_content(@first_user.handle)
      page.should have_content(@second_user.rank)
    end
    it 'renders a link to the user rubygem profile' do
      visit '/users'
      page.all('a', href: "http://rubygems.org/profiles/#{@first_user.profile_id}").should be
      page.all('a', href: "http://rubygems.org/profiles/#{@second_user.profile_id}").should be
    end
  end
end
