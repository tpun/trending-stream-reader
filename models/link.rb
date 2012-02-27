module Aji
  # The `Link` is a model that isn't backed by Postgres or Redis and
  # encapsulates all the properties of a hyperlink.
  class Link < String
    attr_accessor :external_id, :type
    def initialize str
      super str
      match_videos
    end

    YOUTUBE_ID_REGEXP = %r<([-_\w]{11})>
    VIMEO_ID_REGEXP = /\d+/
    YOUTUBE_REGEXPS = [
      %r<https?://(?:www\.)?youtube(?:-nocookie)?\.com/v/#{YOUTUBE_ID_REGEXP}["?]?>,
      %r<https?://(?:www\.)?youtube(?:-nocookie)?\.com/watch\?(?:\S&)?v=#{YOUTUBE_ID_REGEXP}[&"]?>,
      %r<https?://(?:youtu|y2u)\.be/#{YOUTUBE_ID_REGEXP}>
    ]
    VIMEO_REGEXP = %r<https?://(?:www\.)?vimeo\.com/(#{VIMEO_ID_REGEXP})>

    def video?
      (@external_id && @type) ? true : false
    end

    def invalid?
      uri = URI.parse self
      uri.path.nil? || uri.host.nil? || !(uri.scheme =~ /https?/)
    end

    # TODO: Implement this. (No shit sherlock)
    def shortened?
      false
    end

    private
    def match_videos
      youtube_match = YOUTUBE_REGEXPS.map do |r|
        self.match r || false
      end.inject { |acc, el| acc ||= el }
      # TODO: Finish implementing vimeo support.
      vimeo_match = self.match VIMEO_REGEXP
      if youtube_match
        @external_id = youtube_match[1]
        @type = 'youtube'
      else
        if vimeo_match
          @external_id = vimeo_match[1]
          @type = 'vimeo'
        end
      end
    end
  end
end
