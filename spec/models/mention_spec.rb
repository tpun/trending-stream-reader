# encoding: utf-8

require_relative '../../app.rb'
include Aji

describe Mention do
  let(:raw) { {"retweet_count"=>0, "favorited"=>false, "text"=>"http://t.co/isjjO1Z2 #ilvolodelmattino", "entities"=>{"urls"=>[{"indices"=>[0, 20], "expanded_url"=>"http://www.youtube.com/watch?v=vlTY77b4070&feature=youtube_gdata_player", "display_url"=>"youtube.com/watch?v=vlTY77…", "url"=>"http://t.co/isjjO1Z2"}], "hashtags"=>[{"text"=>"ilvolodelmattino", "indices"=>[21, 38]}], "user_mentions"=>[]}, "in_reply_to_status_id_str"=>nil, "id_str"=>"174046337262825472", "place"=>nil, "coordinates"=>nil, "in_reply_to_user_id_str"=>nil, "source"=>"<a href=\"http://twitter.com/#!/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>", "in_reply_to_screen_name"=>nil, "geo"=>nil, "retweeted"=>false, "in_reply_to_user_id"=>nil, "possibly_sensitive"=>false, "contributors"=>nil, "in_reply_to_status_id"=>nil, "possibly_sensitive_editable"=>true, "user"=>{"is_translator"=>false, "verified"=>false, "notifications"=>nil, "screen_name"=>"Iltundra", "default_profile"=>true, "lang"=>"it", "time_zone"=>"Amsterdam", "profile_background_color"=>"C0DEED", "id_str"=>"476049083", "geo_enabled"=>false, "profile_background_tile"=>false, "location"=>"", "profile_background_image_url_https"=>"https://si0.twimg.com/images/themes/theme1/bg.png", "profile_sidebar_fill_color"=>"DDEEF6", "followers_count"=>100, "profile_image_url"=>"http://a2.twimg.com/profile_images/1785412991/image_normal.jpg", "description"=>"", "follow_request_sent"=>nil, "following"=>nil, "profile_image_url_https"=>"https://si0.twimg.com/profile_images/1785412991/image_normal.jpg", "default_profile_image"=>false, "profile_sidebar_border_color"=>"C0DEED", "favourites_count"=>0, "contributors_enabled"=>false, "profile_use_background_image"=>true, "friends_count"=>47, "protected"=>false, "profile_text_color"=>"333333", "name"=>"Cristian iltundra", "statuses_count"=>105, "profile_background_image_url"=>"http://a0.twimg.com/images/themes/theme1/bg.png", "created_at"=>"Fri Jan 27 18:26:14 +0000 2012", "id"=>476049083, "show_all_inline_media"=>false, "listed_count"=>0, "utc_offset"=>3600, "profile_link_color"=>"0084B4", "url"=>"http://www.iseocar.it"}, "truncated"=>false, "id"=>174046337262825472, "created_at"=>"Mon Feb 27 08:20:55 +0000 2012"} }
  let(:video) { Video.new 'vlTY77b4070', 'youtube' }
  let(:author) { Author.new '476049083', 'twitter', {friends: 47, followers: 100} }
  subject { Mention.new raw }

  describe ".initialize" do
    it "sets uid" do
      subject.uid.should == "174046337262825472"
    end

    it "marks the given video mentioned by the author of the mention" do
      expect { subject }.
        to change { video.mention_count(author) }.by(1)
    end

    let(:raw_retweet) { {"contributors"=>nil, "text"=>"RT @DATDUDE_AQUEST: @SheeSoDucci I NEEDS YOUR BADDASS IN THE BUILDING YOUNG LADIES FREE ALL NIGHT $5 CIROC AND SHIT WHATS GOOD http://t. ...", "entities"=>{"urls"=>[], "user_mentions"=>[{"screen_name"=>"DATDUDE_AQUEST", "indices"=>[3, 18], "name"=>"A-Quest", "id_str"=>"77364349", "id"=>77364349}, {"screen_name"=>"SheeSoDucci", "indices"=>[20, 32], "name"=>"Me, Myself,& I", "id_str"=>"205087851", "id"=>205087851}], "hashtags"=>[]}, "in_reply_to_user_id"=>nil, "retweeted_status"=>{"possibly_sensitive"=>false, "contributors"=>nil, "text"=>"@SheeSoDucci I NEEDS YOUR BADDASS IN THE BUILDING YOUNG LADIES FREE ALL NIGHT $5 CIROC AND SHIT WHATS GOOD http://t.co/GDZez9GG", "entities"=>{"urls"=>[{"indices"=>[107, 127], "expanded_url"=>"http://www.youtube.com/watch?v=2M7TlLBgMq8&feature=related", "display_url"=>"youtube.com/watch?v=2M7TlL…", "url"=>"http://t.co/GDZez9GG"}], "user_mentions"=>[{"screen_name"=>"SheeSoDucci", "indices"=>[0, 12], "name"=>"Me, Myself,& I", "id_str"=>"205087851", "id"=>205087851}], "hashtags"=>[]}, "in_reply_to_user_id"=>205087851, "possibly_sensitive_editable"=>true, "place"=>nil, "retweeted"=>false, "coordinates"=>nil, "retweet_count"=>0, "source"=>"web", "in_reply_to_status_id_str"=>"174368842238263296", "geo"=>nil, "in_reply_to_status_id"=>174368842238263296, "favorited"=>false, "in_reply_to_user_id_str"=>"205087851", "id_str"=>"174383735729426432", "user"=>{"notifications"=>nil, "friends_count"=>2565, "profile_sidebar_border_color"=>"eeeeee", "screen_name"=>"DATDUDE_AQUEST", "contributors_enabled"=>false, "lang"=>"en", "statuses_count"=>36760, "profile_use_background_image"=>true, "location"=>"I'm from DC soufside til I die", "listed_count"=>43, "profile_text_color"=>"333333", "followers_count"=>2682, "profile_image_url"=>"http://a1.twimg.com/profile_images/1776430605/me_in_lotus_moe_normal.jpg", "description"=>"I'm just trying do something that's never been done before. I promo positivity. #LOTUSWEDNESDAYS $5 CIROC FUCK WITH ME!!! ", "is_translator"=>false, "show_all_inline_media"=>false, "following"=>nil, "profile_background_image_url"=>"http://a1.twimg.com/profile_background_images/390224580/something_cool.jpg", "default_profile"=>false, "profile_link_color"=>"009999", "time_zone"=>"Alaska", "verified"=>false, "geo_enabled"=>false, "profile_background_image_url_https"=>"https://si0.twimg.com/profile_background_images/390224580/something_cool.jpg", "profile_background_color"=>"131516", "protected"=>false, "id_str"=>"77364349", "profile_background_tile"=>true, "profile_image_url_https"=>"https://si0.twimg.com/profile_images/1776430605/me_in_lotus_moe_normal.jpg", "name"=>"A-Quest", "default_profile_image"=>false, "follow_request_sent"=>nil, "created_at"=>"Sat Sep 26 01:38:29 +0000 2009", "profile_sidebar_fill_color"=>"efefef", "id"=>77364349, "utc_offset"=>-32400, "favourites_count"=>296, "url"=>nil}, "in_reply_to_screen_name"=>"SheeSoDucci", "truncated"=>false, "id"=>174383735729426432, "created_at"=>"Tue Feb 28 06:41:37 +0000 2012"}, "place"=>nil, "retweeted"=>false, "coordinates"=>nil, "retweet_count"=>0, "source"=>"<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>", "in_reply_to_status_id_str"=>nil, "geo"=>nil, "in_reply_to_status_id"=>nil, "favorited"=>false, "in_reply_to_user_id_str"=>nil, "id_str"=>"174391959706812416", "user"=>{"notifications"=>nil, "friends_count"=>643, "profile_sidebar_border_color"=>"eeeeee", "screen_name"=>"JusPaul202", "contributors_enabled"=>false, "lang"=>"en", "statuses_count"=>22640, "profile_use_background_image"=>true, "location"=>"Washington, DC", "listed_count"=>7, "profile_text_color"=>"333333", "followers_count"=>858, "profile_image_url"=>"http://a0.twimg.com/profile_images/1851609034/74KVHp7j_normal", "description"=>"1/4 of @TopShelfStarz & THE BEST R&B ARTIST IN THE DMV #stamped listen to #LEFTFIELD http://soundcloud.com/juspaul202/sets/leftfield", "is_translator"=>false, "show_all_inline_media"=>true, "following"=>nil, "profile_background_image_url"=>"http://a2.twimg.com/profile_background_images/424469352/IMG_0542.jpg", "default_profile"=>false, "profile_link_color"=>"009999", "time_zone"=>"Central Time (US & Canada)", "verified"=>false, "geo_enabled"=>true, "profile_background_image_url_https"=>"https://si0.twimg.com/profile_background_images/424469352/IMG_0542.jpg", "profile_background_color"=>"030405", "protected"=>false, "id_str"=>"96996881", "profile_background_tile"=>true, "profile_image_url_https"=>"https://si0.twimg.com/profile_images/1851609034/74KVHp7j_normal", "name"=>"Paul Spires", "default_profile_image"=>false, "follow_request_sent"=>nil, "created_at"=>"Tue Dec 15 15:02:51 +0000 2009", "profile_sidebar_fill_color"=>"efefef", "id"=>96996881, "utc_offset"=>-21600, "favourites_count"=>7, "url"=>"http://www.reverbnation.com/juspaul202"}, "in_reply_to_screen_name"=>nil, "truncated"=>true, "id"=>174391959706812416, "created_at"=>"Tue Feb 28 07:14:17 +0000 2012"} }
    it "works with retweet" do
      lambda { retweet = Mention.new raw_retweet }.should_not raise_error
    end

    context "when we get a tweet that doesn't include a valid youtube link" do
      let(:invalid_raw) { {"coordinates"=>nil, "text"=>"@JordiLobato..http://www.youtube.com/watch?v=KnUvEYtmHDU&feature=youtube_gdata_player.. @s_gaher ..  #manoleando", "in_reply_to_status_id_str"=>nil, "retweet_count"=>0, "in_reply_to_user_id"=>403592114, "in_reply_to_user_id_str"=>"403592114", "favorited"=>false, "source"=>"<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>", "created_at"=>"Tue Mar 27 07:48:58 +0000 2012", "id_str"=>"184547546813829120", "entities"=>{"urls"=>[], "hashtags"=>[{"text"=>"manoleando", "indices"=>[101, 112]}], "user_mentions"=>[{"indices"=>[0, 12], "id_str"=>"403592114", "screen_name"=>"JordiLobato", "name"=>"Jordi Garcia Lobato", "id"=>403592114}, {"indices"=>[88, 96], "id_str"=>"536274297", "screen_name"=>"s_gaher", "name"=>"sergio garcia", "id"=>536274297}]}, "contributors"=>nil, "place"=>nil, "in_reply_to_screen_name"=>"JordiLobato", "geo"=>nil, "in_reply_to_status_id"=>nil, "user"=>{"show_all_inline_media"=>false, "profile_text_color"=>"333333", "notifications"=>nil, "profile_background_image_url"=>"http://a0.twimg.com/images/themes/theme19/bg.gif", "listed_count"=>0, "profile_link_color"=>"0099CC", "description"=>"", "default_profile"=>false, "profile_background_image_url_https"=>"https://si0.twimg.com/images/themes/theme19/bg.gif", "created_at"=>"Mon May 24 10:11:06 +0000 2010", "profile_background_color"=>"FFF04D", "followers_count"=>19, "profile_image_url"=>"http://a0.twimg.com/profile_images/1843088243/mUavkMyV_normal", "id_str"=>"147516815", "is_translator"=>false, "lang"=>"es", "profile_background_tile"=>false, "url"=>nil, "profile_image_url_https"=>"https://si0.twimg.com/profile_images/1843088243/mUavkMyV_normal", "profile_sidebar_fill_color"=>"f6ffd1", "screen_name"=>"MestreEstellico", "verified"=>false, "protected"=>false, "default_profile_image"=>false, "contributors_enabled"=>false, "statuses_count"=>173, "following"=>nil, "geo_enabled"=>false, "profile_sidebar_border_color"=>"fff8ad", "location"=>"", "name"=>"Oscar", "follow_request_sent"=>nil, "favourites_count"=>56, "id"=>147516815, "profile_use_background_image"=>true, "time_zone"=>"Greenland", "utc_offset"=>-10800, "friends_count"=>131}, "id"=>184547546813829120, "retweeted"=>false, "truncated"=>false} }
      specify "we throw :invalid_raw error" do
        expect { Mention.new invalid_raw }.
          to throw_symbol :invalid_raw
      end
    end
  end

  describe "#author" do
    it "parses out the author" do
      subject.author.uid.should == author.uid
    end
  end

  describe "#video" do
    it "parses out the video" do
      subject.video.uid.should == video.uid
    end
  end

  describe "#text" do
    it "returns the text of the tweet" do
      subject.text.should == "http://t.co/isjjO1Z2 #ilvolodelmattino"
    end
  end

  describe "#mark_spam" do
    it "marks @video spam as well" do
      subject.video.should_receive(:check_spam).with(subject)

      subject.mark_spam
    end
  end

  describe "#spam?" do
    it "returns true if author is spamming this video" do
      subject.video.should_receive(:spammed_by?).
        with(subject.author).
        and_return(true)

      subject.should be_spam
    end

    it "returns true if author is likely to be a spammer" do
      subject.author.stub :spammer? => true

      subject.should be_spam
    end

    it "returns true if video is spam" do
      subject.video.stub :spam? => true

      subject.should be_spam
    end

    it "returns false otherwise" do
      subject.video.should_receive(:spammed_by?).
        with(subject.author).
        and_return(false)

      subject.should_not be_spam
    end
  end

  describe "#english?" do
    it "returns true if the text is in ascii only" do
      subject.should be_english
    end

    it "returns false otherwise" do
      subject.stub :text => " المالكي انشر للجميع"

      subject.should_not be_english
    end
  end

  describe "#relevance" do
    it "is a positive number" do
      subject.relevance.should > 0
    end

    it "depends on the author relevnace ratio" do
      influencer = Author.new 'blah', 'twitter', {friends: 10, followers: 10000}
      subject.author.stub :relevance_ratio => influencer.relevance_ratio

      subject.relevance.should == Mention::Relevance * influencer.relevance_ratio
    end
  end

end