module Aji
  class Author
    attr_reader :uid, :source
    def initialize uid, source
      @uid = uid
      @source = source
    end
  end
end