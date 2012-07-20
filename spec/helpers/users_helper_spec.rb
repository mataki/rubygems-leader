require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe UsersHelper do
  context 'rubygems_url' do
    it 'returns the rubygems url for the specified profile_id' do
      helper.rubygems_url(1).should == 'http://rubygems.org/profiles/1'
    end
  end
end
