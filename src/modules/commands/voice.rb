module UserTimeout
	attr_accessor  :lastPlayed
end

module Bot::DiscordCommands
    module Voice extend Discordrb::Commands::CommandContainer
      command(:join) do |event|
        channel = event.author.voice_channel
        if channel
          Bot::BOT.voice_connect(channel)
        else
          event.channel.send_message ":x: You are not connected to any voice channels"
        end
        return
      end
    end
end