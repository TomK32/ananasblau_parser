module Ananasblau
  module Parsers
    class Vote
      def parse(input)
    #    if Twitter.usernames(input).empty?
      
        case input.split(" ")[1] || input
        when /^\@/ # vote by user name
          return :vote, {:user_screen_name => input.split(" ")[1][1..-1], 
              :value => input.split(" ")[2..-1].join(' ') }
        when /^\#?\d+/ # vote by survey id
          return :vote, {:id => input.split(" ")[1][/\d+/], 
              :value => input.split(" ")[2..-1].join(' ')}
        when 'list'
          return :list
        when 'create' # a new survey
        else
          return :create, {:question => input[/.*?( new)? (.*?\?)/].gsub(/.*? new /, ''),
            :options => input[/\?.*/][1..-1].split(',').map!{|w| w.strip.gsub(/\s+/, ' ')}}
        end
      end

      def process(reply_type, reply, data, user)
        case reply_type
        when :survey
    #      logger.debug("creating a new survey: %s" % data)
          process_survey(reply, data, user)
        when :vote
          process_vote(reply, data, user)
        when :error
    #      logger.error "Bad input from %s: %s" % [data, user]
        end
      end

      def process_survey(reply, data, user)
        survey = user.surveys.find_or_initialize_by_twitter_id(reply.id)
        return true unless survey.new_record?
        survey.attributes = {:question => data[:question],
          :options => data[:options],
          :user_id => user.id,
          :user_screen_name => user.screen_name,
          :user_profile_image_url => user.profile_image_url}
      end
  
      def process_vote(reply, data, user)
        if data[:id]
          survey = Survey.find_by_id(data[:id])
        elsif data[:user_screen_name]
          survey = Survey.last.find_by_user_screen_name(data[:user_screen_name])
        else
          # error
        end
        if survey.options.blank? or survey.options.include?(data[:value])
          vote = survey.votes.find_or_initialize_by_twitter_id(reply.id)
          return true unless vote.new_record?
          vote.option = data[:value]
          vote.user = user
          vote.save
        else
          # error
        end
      end
    end
  end
end