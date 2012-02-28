require_relative '../../../app.rb'
include Aji::Queues::Trending

describe Refresh do
  subject { Refresh }
  let(:trending) { Trending.new('youtube').tap do |t|
      Trending.stub(:new).with('youtube').and_return t
    end }

  describe ".perform" do
    it "refreshes trending channel" do
      trending.should_receive(:refresh).once

      subject.perform
    end
  end
end
