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
				embed.add_field name: "**Dota3 :**", value: "``\\dota``"
				embed.add_field name: "**Notes to Future :**", value: "``\\notes``"
			end
	  end
  end
end