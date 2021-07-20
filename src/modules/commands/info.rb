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
		  embed.add_field name: "**Commands Available**\n", value: " **\\nist_info**    : Display this info\n**\\nist_stats**    : Get all batch counts\n **\\nist_others**    : Get users without batch info\n **\\nist_export [batch]** : Export users with username (with batch filter)\n**\\nist_poll {type} {survey} {option1} {option2} ...** : Create Poll\n\n **Poll Types** : \ncolors\nshapes\nnumbers\nletters\nfood\nfaces\nanimals\ntransportation\n"
		  embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(
            url: 'https://cdn4.iconfinder.com/data/icons/school-subjects/256/Informatics-512.png'
          )
		end
	  end
	  
  end
end