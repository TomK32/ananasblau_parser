module Ananasblau
  module Parsers
    class Twitter
      def usernames(string)
        string.scan(/@(\w+)/).flatten
      end
    end
  end
end