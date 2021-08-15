module Bot::DiscordCommands
  module Help
    extend Discordrb::Commands::CommandContainer
	  
	  command(:help) do |event|
			event.channel.send_embed do |embed|
				embed.colour = 0xff8040
				embed.add_field name: "**Information :**", value: "``\\info``"
				embed.add_field name: "**Ping :**", value: "``\\ping``"
				embed.add_field name: "**Cards againt humanity :**", value: "``\\cah``"
				embed.add_field name: "**Date marry kill :**", value: "``\\fmk``"
				embed.add_field name: "**Trade :**", value: "``\\trade help``"
				embed.add_field name: "**Reminders :**", value: "``\\remind_me <time>``"
				embed.add_field name: "**Polls :**", value: "``\\poll <poll type> <ques> <options> ...``"
				embed.add_field name: "**Jobs :**", value: "``\\jobs <location> <keywords>...``"
			end
	  end
  end
end