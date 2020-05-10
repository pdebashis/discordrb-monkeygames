module Bot::DiscordCommands
  module Info
    extend Discordrb::Commands::CommandContainer
	  
	  command(:info) do |event|
				event.channel.send_embed do |embed|
				embed.colour = 0xff8040
				embed.add_field name: "**Information**", value: " **Name**    : Dota3 Game Bot \n **Version**   : 1.0 \n **Developer** : [@pdebashis](https://github.com/pdebashis)\n **Written**   : Ruby Language (discordrb)\n **Link** : [Invite Link](#{Bot::BOT.invite_url})"
				end
	  end
	  
  end
end