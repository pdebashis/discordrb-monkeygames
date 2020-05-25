module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module Fmk
      extend Discordrb::Commands::CommandContainer
      # Creates a new game
      command(:fmk) do |event,tag|

        tag = Database::FmkOption.all
                                .collect { |e| e.tag }
                                .sample if tag.nil?

        option = Database::FmkOption.where(Sequel.ilike(:tag, tag)).map(:options).sample

        unless option.nil?
          a,b,c = option.split(",")
          event << "``#{a}``▫️``#{b}``▫️``#{c}``"
          event << "Pick one of the above to fuck :eggplant:, one to marry :ring:, and one to kill :dagger:. Choose wisely!"
          event << "***Answer using 1,2 and 3!***"
          
          event.user.await(:choices) do |choices_event|
            f,m,k = choices_event.message.content.split(",")

            choices_event.respond("Showing Overall Stats")
          end
        
          return
        end
        'Under Construction'
      end
   end
  end
end