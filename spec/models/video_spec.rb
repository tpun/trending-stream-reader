# encoding: utf-8

require_relative '../../app.rb'
include Aji

describe Video do
  subject { Video.new 'abc' }
  let(:raw) { {"retweet_count"=>0, "favorited"=>false, "text"=>"http://t.co/isjjO1Z2 #ilvolodelmattino", "entities"=>{"urls"=>[{"indices"=>[0, 20], "expanded_url"=>"http://www.youtube.com/watch?v=vlTY77b4070&feature=youtube_gdata_player", "display_url"=>"youtube.com/watch?v=vlTY77…", "url"=>"http://t.co/isjjO1Z2"}], "hashtags"=>[{"text"=>"ilvolodelmattino", "indices"=>[21, 38]}], "user_mentions"=>[]}, "in_reply_to_status_id_str"=>nil, "id_str"=>"174046337262825472", "place"=>nil, "coordinates"=>nil, "in_reply_to_user_id_str"=>nil, "source"=>"<a href=\"http://twitter.com/#!/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>", "in_reply_to_screen_name"=>nil, "geo"=>nil, "retweeted"=>false, "in_reply_to_user_id"=>nil, "possibly_sensitive"=>false, "contributors"=>nil, "in_reply_to_status_id"=>nil, "possibly_sensitive_editable"=>true, "user"=>{"is_translator"=>false, "verified"=>false, "notifications"=>nil, "screen_name"=>"Iltundra", "default_profile"=>true, "lang"=>"it", "time_zone"=>"Amsterdam", "profile_background_color"=>"C0DEED", "id_str"=>"476049083", "geo_enabled"=>false, "profile_background_tile"=>false, "location"=>"", "profile_background_image_url_https"=>"https://si0.twimg.com/images/themes/theme1/bg.png", "profile_sidebar_fill_color"=>"DDEEF6", "followers_count"=>3, "profile_image_url"=>"http://a2.twimg.com/profile_images/1785412991/image_normal.jpg", "description"=>"", "follow_request_sent"=>nil, "following"=>nil, "profile_image_url_https"=>"https://si0.twimg.com/profile_images/1785412991/image_normal.jpg", "default_profile_image"=>false, "profile_sidebar_border_color"=>"C0DEED", "favourites_count"=>0, "contributors_enabled"=>false, "profile_use_background_image"=>true, "friends_count"=>47, "protected"=>false, "profile_text_color"=>"333333", "name"=>"Cristian iltundra", "statuses_count"=>105, "profile_background_image_url"=>"http://a0.twimg.com/images/themes/theme1/bg.png", "created_at"=>"Fri Jan 27 18:26:14 +0000 2012", "id"=>476049083, "show_all_inline_media"=>false, "listed_count"=>0, "utc_offset"=>3600, "profile_link_color"=>"0084B4", "url"=>"http://www.iseocar.it"}, "truncated"=>false, "id"=>174046337262825472, "created_at"=>"Mon Feb 27 08:20:55 +0000 2012"} }
  let(:mention) { Mention.new raw}
  let(:nonspammer) { Author.new('nonspammer', 'twitter') }

  describe "#spammed_by?" do
    it "returns true if given mentioner has mentioned given video more than twice" do
      3.times { subject.mentioned_in mention }

      subject.should be_spammed_by(mention.author)
    end

    it "returns false otherwise" do
      subject.should_not be_spammed_by(nonspammer)
    end
  end

  describe "#mentioned_by" do
    it "adds given mentioner to the list" do
      expect { subject.mentioned_in(mention) }.
        to change { subject.mention_count(mention.author) }.by(1)
    end

    it "sets an expiry date on the key" do
      subject.should_receive(:expire_keys).once

      subject.mentioned_in mention
    end
  end

  describe "#mention_count" do
    let(:count) { 3 }
    it "returns count of number of mentions from the mentioner" do
      count.times do |n|
        mention.stub :uid => n
        subject.mentioned_in mention
      end

      subject.mention_count(mention.author).should == count
    end

    it "returns count of all mentions if mentioner is absent" do
      subject.mentioned_in mention
      # different mention with different author
      mention.stub :author => Author.new('blah', 'twitter')
      mention.stub :uid => 456
      subject.mentioned_in mention

      subject.mention_count.should == 2
    end
  end

  describe "#expire_keys" do
    before :each do # since you can't set expire on empty keys
      subject.mentioned_in mention
    end

    it "expires all keys" do
      subject.keys.each_pair do |name, key|
        Aji.redis.ttl(key).should > 0
      end
    end
  end
end