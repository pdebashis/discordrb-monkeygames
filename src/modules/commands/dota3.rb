module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module Dota
      extend Discordrb::Commands::CommandContainer
      # Creates a new game
      command(:dota) do |event|

        info = """
   🗳 **__How to Play__**

  :writing_hand: **Under Development**  

  🔰 **Need help? Questions? Problems?**
  Ask `codemonkey#2455`!

  """
        event.channel.send_message info
        "***Type Ready to enter the game!***"
      end
    end
  end
end