require 'spec_helper'

def rubygems_is_up?
  begin
    Mechanize.new.get('http://status.rubygems.org')
  rescue Exception => response_error
    puts 'status.rubygems.org returned' << response_error.inspect.to_s
    false
  end
end

describe Fetcher do

  context 'fetching' do
    # NOTE This is using qrush's rubygems profile. Short of pulling the rubygems repo 
    # and spinning up an instance this is a close to reality as we can get.
    before :all do
      pending 'cannot connect to rubygems' unless rubygems_is_up?
      fetcher = Fetcher.new(1)
      @fetcher_data = fetcher.get
    end

    it "retrieves the user's handle" do
      @fetcher_data[:handle].should eq('qrush')
    end
    it "retrieves the user's email" do
      @fetcher_data[:email].should eq('nick@quaran.to')
    end

    it "retrieves the user's total downloads" do
      @fetcher_data[:total_downloads].should >= 3808238
    end
  end
end
