module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module Fmk
      extend Discordrb::Commands::CommandContainer
      # Creates a new game
      command(:fmk) do |event|
        event << "Under development!"
        event << "Pick one of the above to fuck, one to marry, and one to kill. Choose wisely!"
        event << "***Answer using 1,2 and 3!***"
      end
   end
  end
end