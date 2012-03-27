require_relative '../../../app.rb'
include Aji
include Aji::Queues::Trending

describe PromoteVideo do
  subject { PromoteVideo }
  let(:tweet) { mock }
  let(:mention) {
    mock.tap do |m|
      Mention.stub(:new).with(tweet).and_return(m)
      m.stub :spam? => false
      m.stub :english? => true
      m.stub :video => mock(:uid => 'abc', :source => 'youtube')
      m.stub :relevance => 1000
      m.stub :mark_spam => true
    end
  }
  let(:trending) {
    mock.tap do |t|
      Trending.stub(:new).and_return(t)
    end
  }

  describe ".perform" do
    it "ignores invalid mention" do
      Mention.stub(:new).with(tweet).and_throw(:invalid_raw)
      trending.should_not_receive :promote_video

      subject.perform tweet
    end

    it "ignores and marks spammy mentions" do
      mention.should_receive(:spam?).and_return(true)
      mention.should_receive(:mark_spam)
      trending.should_not_receive(:promote_video)

      subject.perform tweet
    end

    it "drops non english mentions" do
      mention.stub :english? => false
      trending.should_not_receive :promote_video

      subject.perform tweet
    end

    it "updates trending channel with given mention" do
      trending.should_receive(:promote_video).
        with(mention.video, mention.relevance)

      subject.perform tweet
    end
  end
end
