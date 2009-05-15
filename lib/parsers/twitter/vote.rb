module Ananasblau
  module Parsers
    class Vote
      # can handle following commands:
      # * create (which is also default) for new votings
      def parse(input)
        case input.split(" ")[1] || input
        when /^\@/ # vote by user name
          value = input.split(" ")[2..-1].join(' ')
          return :error if value.blank?
          return :vote, {:user_screen_name => input.split(" ")[1][1..-1], :value => value }
        when /^\#?\d+/ # vote by survey id
          value = input.split(" ")[2..-1].join(' ')
          return :error if value.blank?
          return :vote, {:id => input.split(" ")[1][/\d+/], :value => value}
        when 'list'
          return :list
        when 'create' # a new survey
        else
          if input.match(/\?/)
            # options are everything from the ? on
            options = input[/\?.*/][1..-1].split('.')
            if options.size == 1
              options = input[/\?.*/][1..-1].split(' ')
            end
            return :create, {:question => input[/.*?( create)? (.*?\?)/].gsub(/.*?( create)?\? /, ''),
              :options => options.map!{|w| w.strip.gsub(/\s+/, ' ')}}
          else
            return :error
          end
        end
      end
    end
  end
end