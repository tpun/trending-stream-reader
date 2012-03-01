require_relative '../../../app.rb'
include Aji::Queues::Trending

describe PromoteVideo do
  subject { PromoteVideo }
  let(:tweet) { mock }
  let(:mention) {
    mock.tap do |m|
      Mention.stub(:new).with(tweet).and_return(m)
      m.stub :spam? => false
      m.stub :video => mock(:uid => 'abc', :source => 'youtube')
      m.stub :relevance => 1000
    end
  }
  let(:trending) {
    mock.tap do |t|
      Trending.stub(:new).and_return(t)
    end
  }

  describe ".perform" do
    it "drops spammy mentions" do
      mention.should_receive(:spam?).and_return(true)
      trending.should_not_receive(:promote_video)

      subject.perform tweet
    end

    it "updates trending channel with given mention" do
      trending.should_receive(:promote_video).with(mention)

      subject.perform tweet
    end
  end
end
