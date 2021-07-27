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
				embed.add_field name: "**Trade :**", value: "``\\trade``"
				embed.add_field name: "**Reminders :**", value: "``\\remind_me``"
			end
	  end
  end
end