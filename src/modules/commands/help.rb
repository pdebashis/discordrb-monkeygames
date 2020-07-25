module Bot::DiscordCommands
  module Help
    extend Discordrb::Commands::CommandContainer
	  
	  command(:help) do |event|
			event.channel.send_embed do |embed|
				embed.colour = 0xff8040
				embed.add_field name: "**information :**", value: "``\\info``"
				embed.add_field name: "**ping :**", value: "``\\ping``"
				embed.add_field name: "**cards againt humanity :**", value: "``\\cah``"
				embed.add_field name: "**date marry kill :**", value: "``\\fmk``"
				embed.add_field name: "**dota3 :**", value: "``\\dota``"
			end
	  end
  end
end