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

  describe "#irrelevant?" do
    subject = Author.new 'blah', 'twitter', { friends: 30, followers: 30}

    it "true if relevance_ratio is low" do
      subject.stub :relevance_ratio => 0.1

      subject.should be_irrelevant
    end

    it "true if the sum of friends and followers is less than threshold" do
      spammer = Author.new 'blah', 'twitter', { friends: 10, followers: 0}

      spammer.should be_irrelevant
    end

    it "true if he only follows a very small number of people." do
      spammer = Author.new 'blah', 'twitter', { friends: 5, followers: 10000 }

      spammer.should be_irrelevant
    end

    it "returns false otherwise" do
      subject.should_not be_irrelevant
    end
  end

  describe "#spammer?" do
    subject = Author.new 'blah', 'twitter', { friends: 30, followers: 30}

    it "is true if author is irrelevant" do
      subject.stub :irrelevant? => true

      subject.should be_irrelevant
    end
  end
end