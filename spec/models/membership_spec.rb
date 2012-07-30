require 'spec_helper'

describe Membership do
  context 'associations' do 
    it { should belong_to :user }
    it { should belong_to :team }
  end
end
