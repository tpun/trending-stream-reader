module Aji
  class Author
    attr_reader :uid, :source, :friends, :followers
    def initialize uid, source, count
      @uid = uid
      @source = source

      # count only
      @friends = count[:friends]
      @followers = count[:followers]
    end

    def relevance_ratio # 0.0 .. 3.0
      @relevance_ratio ||= [@followers / ( 1.0 + @friends), 3.0].min
    end

    def spammer?
      relevance_ratio < 0.2
    end
  end
end