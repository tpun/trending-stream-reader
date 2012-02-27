module Aji
  class Mention
    attr_reader :raw, :source, :uid, :author_uid
    attr_reader :video

    def initialize raw, source='twitter'
      @raw = raw
      @source = source

      @uid = @raw["id_str"]
      @author_uid = @raw["user"]["id_str"]

      url_entity = @raw["entities"]["urls"].first
      video_link = Link.new url_entity["expanded_url"]
      @video_uid = video_link.external_id
      @video_source = video_link.type

      @video = Video.new @video_uid, @video_source
      @video.mentioned @author_uid
    end

    def spam?
      @video.spammed_by? @author_uid
    end
  end
end