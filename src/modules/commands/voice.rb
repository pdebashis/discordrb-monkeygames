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

      command(:play) do |event|
        sound_file = "sounds/pudge_make_room_for_pudge.mp3"
        unless ::File::exist?(sound_file)
          event.channel.send_message ':x: Sound File doesnt exist'
          next
        end

      voice = event.voice
      if voice
        to_disconnect = false
      else
        channel = event.author.voice_channel
        unless channel
          event.channel.send_message ':x: You are not connected to any voice channels'
          next
        end
        voice = Bot::BOT.voice_connect(channel)
        to_disconnect = true
      end
      voice.play_file(sound_file)
      Bot::BOT.voice_destroy(event.server) if to_disconnect
    end
  end
end
