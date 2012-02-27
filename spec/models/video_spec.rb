require_relative '../../app.rb'
include Aji

describe Video do
  subject { Video.new 'abc' }
  let(:spammer) { Author.new('spammer', 'twitter') }
  let(:nonspammer) { Author.new('nonspammer', 'twitter') }

  describe "#spammed_by?" do
    it "returns true if given mentioner has mentioned given video more than twice" do
      3.times { subject.mentioned_by spammer }

      subject.should be_spammed_by(spammer)
    end

    it "returns false otherwise" do
      subject.should_not be_spammed_by(nonspammer)
    end
  end

  describe "#mentioned_by" do
    it "adds given mentioner to the list" do
      expect { subject.mentioned_by(nonspammer) }.
        to change { subject.mention_count(nonspammer) }.by(1)
    end

    it "sets an expiry date on the key" do
      subject.mentioned_by nonspammer

      Aji.redis.ttl(subject.key).should > 0
    end
  end

  describe "#mention_count" do
    let(:count) { 3 }
    it "returns count of number of mentions from the mentioner" do
      count.times { subject.mentioned_by(spammer) }

      subject.mention_count(spammer).should == count
    end
  end
end