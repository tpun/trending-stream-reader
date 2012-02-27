require 'time'

module Aji
  class Mention
    attr_reader :raw, :source, :uid
    attr_reader :author, :video

    def initialize raw, source='twitter'
      @raw = raw
      @source = source
      @uid = @raw["id_str"]
      @created_at = Time.parse @raw["created_at"]
      @author = Author.new @raw["user"]["id_str"], @source

      url_entity = @raw["entities"]["urls"].first
      video_link = Link.new url_entity["expanded_url"]
      @video_uid = video_link.external_id
      @video_source = video_link.type

      @video = Video.new @video_uid, @video_source
      @video.mentioned_by @author, @uid, @created_at
    end

    def spam?
      @video.spammed_by? @author
    end
  end
end