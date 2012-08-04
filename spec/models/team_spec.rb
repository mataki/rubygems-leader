require 'spec_helper'

describe Team do

  context 'associations' do
    it { should have_many :memberships }
    it { should have_many :users, through: :memberships }
  end
end
