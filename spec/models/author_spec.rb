# encoding: utf-8

require_relative '../../app.rb'
include Aji

describe Author do

  describe "#relevance_ratio" do
    it "is 1.0 if author has the same number of friends and followers" do
      normal_guy = Author.new 'blah', 'twitter', { friends: 10, followers: 10}

      normal_guy.relevance_ratio.should be_within(0.1).of(1.0)
    end

    it "max is 3.0" do
      influencer = Author.new 'blah', 'twitter', { friends: 10, followers: 1000}

      influencer.relevance_ratio.should == 3.0
    end

    it "min is 0.0" do
      spammer = Author.new 'blah', 'twitter', { friends: 10000, followers: 10}

      spammer.relevance_ratio.should be_within(0.1).of(0.0)
    end
  end
end