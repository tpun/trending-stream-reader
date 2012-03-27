module Aji
  class Author
    attr_reader :uid, :source, :friends, :followers
    def initialize uid, source, count
      raise "nil uid or source!" if uid.nil? or source.nil?

      @uid = uid
      @source = source

      # count only
      @friends = count[:friends] || 0
      @followers = count[:followers] || 0
    end

    def relevance_ratio # 0.0 .. 3.0
      @relevance_ratio ||= [@followers / ( 1.0 + @friends), 3.0].min
    end

    def irrelevant?
      relevance_ratio < 0.2 or
      (@followers + @friends) < 50 or
      @friends < 10
    end

    def spammer?
      irrelevant?
    end

    def to_s
      "Author: #{@uid} @ #{@source}, followers: #{@followers}, friends: #{@friends}, spammer? #{spammer?}"
    end
  end
end