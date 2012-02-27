module Aji
  class Mention
    attr_reader :raw, :source, :uid, :author_uid
    attr_reader :video

    def initialize raw, source='twitter'
      @raw = raw
      @source = source

      @uid = 0
      @author_uid = 0

      @video_uid = 0
      @video_source = 'youtube'

      @video = Video.new @video_uid, @video_source
      @video.mentioned @author_uid
    end

    def spam?
      @video.spammed_by? @author_uid
    end
  end
end