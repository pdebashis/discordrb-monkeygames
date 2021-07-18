module Bot::DiscordCommands
  module Info
    extend Discordrb::Commands::CommandContainer
	  command(:info) do |event|
		event.channel.send_embed do |embed|
		  embed.colour = 0xff8040
		  embed.add_field name: "**Information**", value: " **Name**    : CodeMonkey Games \n **Version**   : 1.0 \n **Developer** : [@pdebashis](https://pdebashis.github.io)\n **Written In**   : Ruby Language (discordrb)\n **Source**   : [Github](https://github.com/pdebashis/discordrb-dota3)\n **Invite Link** : [Server Invite](#{Bot::BOT.invite_url})"
		end
	  end

	  command(:nist_info) do |event|
		event.channel.send_embed do |embed|
		  embed.colour = 0xff8040
		  embed.add_field name: "**Commands Available**", value: " **\\nist_stats**    : Get all batch counts\n **\\nist_others**    : Get users without batch info\n **\\nist_users**   : Export all users in csv format \n **\\nist_export [batch]** : Export users with username (with batch filter)"
		end
	  end
	  
  end
end