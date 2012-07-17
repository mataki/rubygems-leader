require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, stub_model(User,
      :name => "MyString",
      :email => "MyString",
      :handle => "MyString",
      :profile_id => 1,
      :total_downloads => 1
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_name", :name => "user[name]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_handle", :name => "user[handle]"
      assert_select "input#user_profile_id", :name => "user[profile_id]"
      assert_select "input#user_total_downloads", :name => "user[total_downloads]"
    end
  end
end
