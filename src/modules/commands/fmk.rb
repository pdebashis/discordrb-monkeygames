module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module Fmk
      extend Discordrb::Commands::CommandContainer
      # Creates a new game

      def self.valid(f,m,k)
        if ([1,2,3].include?(f) && [1,2,3].include?(m) && [1,2,3].include?(k))
          return true if f+m+k == 6
        end
        return false
      end

      command(:fmk) do |event,tag|

        tag = Database::FmkTag.all
                                .collect { |e| e.name }
                                .sample if tag.nil?

        fmk_tag = Database::FmkTag.find(Sequel.ilike(:name, tag))

        if fmk_tag.nil?
          'No such Tag'
          return
        end
  
        option = fmk_tag.fmk_options.sample

        unless option.nil?
          a,b,c = option.names.split(",")
          event << "``#{a} (1)``▫️``#{b} (2)``▫️``#{c} (3)``"
          event << "Pick one of the above to date :eggplant:, one to marry :ring:, and one to kill :dagger:. Choose wisely!"
          event << "***Answer using 1,2 and 3!***"

          event.user.await(:choices) do |choices_event|
            f,m,k = choices_event.message.content.split(",").map(&:to_i)

            if !valid(f,m,k)
              choices_event.respond("Didnt Choose Valid options!")
            else
            
              option.update_f! f
              option.update_m! m
              option.update_k! k

              event.channel.send_message(
                "",
                false,
                option.stats
              )
            end
          end
          return
        end
        'Options Under Construction'
      end
   end
  end
end