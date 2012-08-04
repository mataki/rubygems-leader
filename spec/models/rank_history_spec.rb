require 'spec_helper'

describe RankHistory do
  context 'associations' do
    it { should belong_to :user }
  end
end
