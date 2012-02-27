require_relative '../../../app.rb'

describe Queues::Trending::PromoteVideo do
  subject { Queues::Trending::PromoteVideo }
  let(:tweet) { mock }
  let(:mention) {
    mock.tap do |m|
      Mention.stub(:new).with(tweet).and_return(m)
      m.stub :spam? => false
      m.stub :video => mock
      m.stub :significance => 1000
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
      trending.should_receive(:promote_video).
        with(mention.video, mention.significance)

      subject.perform tweet
    end
  end
end