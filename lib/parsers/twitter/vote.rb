module Ananasblau
  module Parsers
    class Vote
      # can handle following commands:
      # * create (which is also default) for new votings
      def parse(input)
        case input.gsub!(/\s+/, ' ').split(" ")[1] || input
        when /^\@/ # vote by user name
          option = input.split(" ")[2..-1].join(' ')
          return :error if option.blank?
          return :vote, {:user_screen_name => input.split(" ")[1][1..-1], :option => option }
        when /^\#?\d+/ # vote by survey id
          option = input.split(" ")[2..-1].join(' ')
          return :error if option.blank?
          return :vote, {:id => input.split(" ")[1][/\d+/], :option => option}
        else
          if input.match(/\?/)
            # options are everything from the ? on
            options = input[/\?.*/][1..-1].split('.')
            if options.size == 1
              options = input[/\?.*/][1..-1].split(' ')
            end
            return :create, {:question => input.gsub(/^(\@\w+?\s)/, '').gsub(/(create|new)/, '').gsub(/\?.*/, '?').strip,
              :options => options.map!{|w| w.strip}}
          else
            return :error
          end
        end
      end
    end
  end
end