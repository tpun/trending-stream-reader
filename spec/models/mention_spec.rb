# encoding: utf-8

require_relative '../../app.rb'
include Aji

describe Mention do
  let(:raw) { {"retweet_count"=>0, "favorited"=>false, "text"=>"http://t.co/isjjO1Z2 #ilvolodelmattino", "entities"=>{"urls"=>[{"indices"=>[0, 20], "expanded_url"=>"http://www.youtube.com/watch?v=vlTY77b4070&feature=youtube_gdata_player", "display_url"=>"youtube.com/watch?v=vlTY77…", "url"=>"http://t.co/isjjO1Z2"}], "hashtags"=>[{"text"=>"ilvolodelmattino", "indices"=>[21, 38]}], "user_mentions"=>[]}, "in_reply_to_status_id_str"=>nil, "id_str"=>"174046337262825472", "place"=>nil, "coordinates"=>nil, "in_reply_to_user_id_str"=>nil, "source"=>"<a href=\"http://twitter.com/#!/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>", "in_reply_to_screen_name"=>nil, "geo"=>nil, "retweeted"=>false, "in_reply_to_user_id"=>nil, "possibly_sensitive"=>false, "contributors"=>nil, "in_reply_to_status_id"=>nil, "possibly_sensitive_editable"=>true, "user"=>{"is_translator"=>false, "verified"=>false, "notifications"=>nil, "screen_name"=>"Iltundra", "default_profile"=>true, "lang"=>"it", "time_zone"=>"Amsterdam", "profile_background_color"=>"C0DEED", "id_str"=>"476049083", "geo_enabled"=>false, "profile_background_tile"=>false, "location"=>"", "profile_background_image_url_https"=>"https://si0.twimg.com/images/themes/theme1/bg.png", "profile_sidebar_fill_color"=>"DDEEF6", "followers_count"=>3, "profile_image_url"=>"http://a2.twimg.com/profile_images/1785412991/image_normal.jpg", "description"=>"", "follow_request_sent"=>nil, "following"=>nil, "profile_image_url_https"=>"https://si0.twimg.com/profile_images/1785412991/image_normal.jpg", "default_profile_image"=>false, "profile_sidebar_border_color"=>"C0DEED", "favourites_count"=>0, "contributors_enabled"=>false, "profile_use_background_image"=>true, "friends_count"=>47, "protected"=>false, "profile_text_color"=>"333333", "name"=>"Cristian iltundra", "statuses_count"=>105, "profile_background_image_url"=>"http://a0.twimg.com/images/themes/theme1/bg.png", "created_at"=>"Fri Jan 27 18:26:14 +0000 2012", "id"=>476049083, "show_all_inline_media"=>false, "listed_count"=>0, "utc_offset"=>3600, "profile_link_color"=>"0084B4", "url"=>"http://www.iseocar.it"}, "truncated"=>false, "id"=>174046337262825472, "created_at"=>"Mon Feb 27 08:20:55 +0000 2012"} }
  subject { Mention.new raw }

  describe ".initialize" do
    it "sets uid and author_uid" do
      subject.uid.should == "174046337262825472"
      subject.author_uid.should == "476049083"
    end

    let(:video) { mock }
    it "marks the given video mentioned by the author of the mention" do
      Video.stub(:new).and_return(video)

      video.should_receive(:mentioned).with(subject.author_uid).once
    end
  end

  describe "#video" do
    it "parses out the video uid" do
      subject.video.uid.should == 'vlTY77b4070'
    end
  end

  describe "#spam?" do
    it "returns true if author is spamming this video" do
      subject.video.should_receive(:spammed_by?).
        with(subject.author_uid).
        and_return(true)

      subject.should be_spam
    end

    it "returns false otherwise" do
      subject.video.should_receive(:spammed_by?).
        with(subject.author_uid).
        and_return(false)

      subject.should_not be_spam
    end
  end
end