# encoding: utf-8

require_relative '../../app.rb'
include Aji

describe Trending do
  let(:raw) { {"retweet_count"=>0, "favorited"=>false, "text"=>"http://t.co/isjjO1Z2 #ilvolodelmattino", "entities"=>{"urls"=>[{"indices"=>[0, 20], "expanded_url"=>"http://www.youtube.com/watch?v=vlTY77b4070&feature=youtube_gdata_player", "display_url"=>"youtube.com/watch?v=vlTY77…", "url"=>"http://t.co/isjjO1Z2"}], "hashtags"=>[{"text"=>"ilvolodelmattino", "indices"=>[21, 38]}], "user_mentions"=>[]}, "in_reply_to_status_id_str"=>nil, "id_str"=>"174046337262825472", "place"=>nil, "coordinates"=>nil, "in_reply_to_user_id_str"=>nil, "source"=>"<a href=\"http://twitter.com/#!/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>", "in_reply_to_screen_name"=>nil, "geo"=>nil, "retweeted"=>false, "in_reply_to_user_id"=>nil, "possibly_sensitive"=>false, "contributors"=>nil, "in_reply_to_status_id"=>nil, "possibly_sensitive_editable"=>true, "user"=>{"is_translator"=>false, "verified"=>false, "notifications"=>nil, "screen_name"=>"Iltundra", "default_profile"=>true, "lang"=>"it", "time_zone"=>"Amsterdam", "profile_background_color"=>"C0DEED", "id_str"=>"476049083", "geo_enabled"=>false, "profile_background_tile"=>false, "location"=>"", "profile_background_image_url_https"=>"https://si0.twimg.com/images/themes/theme1/bg.png", "profile_sidebar_fill_color"=>"DDEEF6", "followers_count"=>3, "profile_image_url"=>"http://a2.twimg.com/profile_images/1785412991/image_normal.jpg", "description"=>"", "follow_request_sent"=>nil, "following"=>nil, "profile_image_url_https"=>"https://si0.twimg.com/profile_images/1785412991/image_normal.jpg", "default_profile_image"=>false, "profile_sidebar_border_color"=>"C0DEED", "favourites_count"=>0, "contributors_enabled"=>false, "profile_use_background_image"=>true, "friends_count"=>47, "protected"=>false, "profile_text_color"=>"333333", "name"=>"Cristian iltundra", "statuses_count"=>105, "profile_background_image_url"=>"http://a0.twimg.com/images/themes/theme1/bg.png", "created_at"=>"Fri Jan 27 18:26:14 +0000 2012", "id"=>476049083, "show_all_inline_media"=>false, "listed_count"=>0, "utc_offset"=>3600, "profile_link_color"=>"0084B4", "url"=>"http://www.iseocar.it"}, "truncated"=>false, "id"=>174046337262825472, "created_at"=>"Mon Feb 27 08:20:55 +0000 2012"} }
  let(:mention) { Mention.new raw }
  let(:video) { mention.video }
  subject { Trending.new }

  describe "#key" do
    it "depends on video source only" do
      yt = Trending.new 'youtube'
      vi = Trending.new 'vimeo'
      yt.key.should_not == vi.key
    end
  end

  describe "#promote_video" do
    it "increments given external id by given relevance" do
      expect { subject.promote_video video, mention.relevance }.
        to change { subject.relevance(video) }.
        by (mention.relevance)
    end

    it "adds video into zset" do
      expect { subject.promote_video video, mention.relevance }.
        to change { subject.video_uids.include? video.uid }.
        from(false).to(true)
    end

    it "only keeps a maximum number of videos"
  end

  describe "#refresh" do
    it "decays all existing videos and removes old ones" do
      subject.should_receive :decay_videos
      subject.should_receive :truncate_videos

      subject.refresh
    end
  end

  describe "#relevance" do
    it "calls relevance_by_uid" do
      subject.should_receive(:relevance_by_uid).with(video.uid)

      subject.relevance video
    end
  end

  describe "#relevance_by_uid" do
    let(:relevance) { 999 }
    let(:uid) { video.uid }
    it "returns relvance previously set" do
      subject.set_relevance_by_uid uid, relevance

      subject.relevance_by_uid(uid).should == relevance
    end
  end

  describe "#set_relevance_by_uid" do
    let(:relevance) { 999 }
    it "updates relevance with given input" do
      subject.promote_video video, mention.relevance
      subject.relevance(video).should_not == relevance

      subject.set_relevance_by_uid video.uid, relevance
      subject.relevance(video).should == relevance
    end
  end

  describe "#decay_videos" do
    let(:percent) { 15 }
    it "decays videos by given discount" do
      subject.promote_video video, mention.relevance

      original = subject.relevance video
      subject.decay_videos percent
      decayed = subject.relevance video

      (100*(original-decayed)/original).should == percent
    end
  end

  describe "#truncate_videos" do
    let(:min_relevance) { 100 }
    before :each do
      subject.promote_video video, min_relevance/2
    end

    it "removes old videos which relevance is lower than given min" do
      subject.truncate_videos min_relevance
      subject.video_uids.should_not include video.uid
    end

    it "destroy the old videos" do
      video.mention_count.should > 0

      subject.truncate_videos min_relevance
      video.mention_count.should == 0
    end
  end
end