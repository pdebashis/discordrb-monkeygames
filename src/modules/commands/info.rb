module Bot::DiscordCommands
  module Info
    extend Discordrb::Commands::CommandContainer
	  
	  command(:info) do |event|
		event.channel.send_embed do |embed|
		  embed.colour = 0xff8040
		  embed.add_field name: "**Information**", value: " **Name**    : CodeMonkey Games \n **Version**   : 1.0 \n **Developer** : [@pdebashis](https://github.com/pdebashis)\n **Written**   : Ruby Language (discordrb)\n **Source**   : [Github](https://github.com/pdebashis/discordrb-dota3)\n **Invite Link** : [Server Invite](#{Bot::BOT.invite_url})"
		end
	  end
	  
  end
end