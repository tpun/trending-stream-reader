require_relative '../../app.rb'
include Aji

describe Video do
  subject { Video.new 'abc' }

  describe "#spammed_by?" do
    let(:spammer) { 10 }
    it "returns true if given mentioner has mentioned given video more than twice" do
      subject.stub(:mention_count).with(spammer).and_return(3)

      subject.should be_spammed_by(spammer)
    end

    let(:nonspammer) { 20 }
    it "returns false otherwise" do
      subject.stub(:mention_count).with(nonspammer).and_return(0)

      subject.should_not be_spammed_by(nonspammer)
    end
  end

  describe "#mentioned" do
    let(:mentioner) { 123 }
    it "adds given mentioner to the list" do
      expect { subject.mentioned(mentioner) }.
        to change { subject.mention_count(mentioner) }.by(1)
    end

    it "sets an expiry date on the key" do
      subject.mentioned mentioner

      Aji.redis.ttl(subject.key).should > 0
    end
  end

  describe "#mention_count" do
    let(:count) { 3 }
    let(:mentioner) { 123 }
    it "returns count of number of mentions from the mentioner" do
      count.times { subject.mentioned(mentioner) }

      subject.mention_count(mentioner).should == count
    end
  end
end