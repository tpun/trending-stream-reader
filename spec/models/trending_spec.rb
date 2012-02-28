require_relative '../../app.rb'
include Aji

describe Trending do
  subject { Trending.new }

  describe "#key" do
    it "depends on video source only" do
      yt = Trending.new 'youtube'
      vi = Trending.new 'vimeo'
      yt.key.should_not == vi.key
    end
  end

  describe "#promote_video" do
    let(:video) { mock(:uid => 'abc') }
    let(:mention) { mock( :video => video,
                          :significance => 100,
                          :author_uid => 200 )}

    it "increments given external id by given significance" do
      Aji.redis.should_receive(:zincrby).with(
        subject.key, mention.significance, mention.video.uid)

      subject.promote_video mention
    end

    it "only keeps a maximum number of videos"
  end

  describe "#refresh" do
    it "decays all existing videos"
    it "removes old videos"
  end
end