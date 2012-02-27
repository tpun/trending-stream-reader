module Aji
  class Mention
    attr_reader :raw, :source, :uid
    attr_reader :video, :author

    def initialize raw, source='twitter'
      @raw = raw
      @source = source

      @uid = @raw["id_str"]
      @author = Author.new @raw["user"]["id_str"], @source

      url_entity = @raw["entities"]["urls"].first
      video_link = Link.new url_entity["expanded_url"]
      @video_uid = video_link.external_id
      @video_source = video_link.type

      @video = Video.new @video_uid, @video_source
      @video.mentioned_by @author
    end

    def spam?
      @video.spammed_by? @author
    end
  end
end