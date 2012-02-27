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
    let(:video_external_id) { 'abc' }
    let(:significance) { 100 }

    it "increments given external id by given significance" do
      Aji.redis.should_receive(:zincrby).with(
        subject.key, significance, video_external_id)

      subject.promote_video video_external_id, significance
    end

    it "only keeps a maximum number of videos"
  end
end