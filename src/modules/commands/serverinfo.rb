module Bot
    module DiscordCommands
        module Serverinfo
    extend Discordrb::Commands::CommandContainer
  
    command(:sinfo, min_args: 0, max_args: 1) do |event, id|
      server = event.server
  
      unless id.nil?
        begin
          server = event.bot.server(id)
        rescue Discordrb::Errors::NoPermission
          event.respond "I am not on that server and are therefore unable to view that server's stats. Try getting them to add me."
          break
        end
      end
  
      if event.channel.pm?
        event.respond "You silly meme, you can't do SERVERinfo in a private message!!! haha, trying to bamboozle, who got bamboozled NOW? But seriously, try running this on a server."
        next
      end
      begin
        event.channel.send_embed do |e|
          e.title = 'Server Information'
  
          e.author = { name: server.name, icon_url: "https://cdn.discordapp.com/icons/#{server.id}/#{server.icon_id}.png?size=1024" }
  
          e.thumbnail = { url: "https://cdn.discordapp.com/icons/#{server.id}/#{server.icon_id}.png?size=1024".to_s }
  
          e.add_field(name: 'Server Owner', value: server.owner.mention, inline: true)
          e.add_field(name: 'Server ID', value: server.id, inline: true)
  
          region = if server.region == 'vip-amsterdam'
                     '<:region_amsterdam:426902668871467008> <:vip_region:426902668909477898> Amsterdam'
                   elsif server.region == 'brazil'
                     '<:region_brazil:426902668561219605> Brazil'
                   elsif server.region == 'eu-central'
                     '<:region_eu:426902669110673408> Central Europe'
                   elsif server.region == 'hongkong'
                     '<:region_hongkong:426902668636585985> Hong Kong'
                   elsif server.region == 'japan'
                     '<:region_japan:426902668578127884> Japan'
                   elsif server.region == 'russia'
                     '<:region_russia:426902668859015169> Russia'
                   elsif server.region == 'singapore'
                     '<:region_singapore:426902668951158784> Singapore'
                   elsif server.region == 'sydney'
                     '<:region_sydney:426902668934643722> Sydney'
                   elsif server.region == 'us-central'
                     '<:region_us:426902668900827146> US Central'
                   elsif server.region == 'us-east'
                     '<:region_us:426902668900827146> US East'
                   elsif server.region == 'vip-us-east'
                     '<:region_us:426902668900827146> <:vip_region:426902668909477898> US East'
                   elsif server.region == 'us-south'
                     '<:region_us:426902668900827146> US South'
                   elsif server.region == 'us-west'
                     '<:region_us:426902668900827146> US West'
                   elsif server.region == 'vip-us-west'
                     '<:region_us:426902668900827146> <:vip_region:426902668909477898> US West'
                   elsif server.region == 'eu-west'
                     '<:region_eu:426902669110673408> Western Europe'
                   else
                     server.region
                   end
  
          e.add_field(name: 'Server Region', value: region, inline: true)
  
          if server.member_count > 500
            e.add_field(name: 'Member Count', value: "Total: #{server.member_count}", inline: true)
          else
            botos = 0
            server.members.each do |meme|
              botos += 1 if meme.bot_account?
            end
  
            members = server.member_count
            humans = members - botos
  
            botpercent = (botos.to_f / members.to_f * 100).round(2).to_s
            humanpercent = (humans.to_f / members.to_f * 100).round(2).to_s
  
            e.add_field(name: 'Member Count', value: [
              "Total: #{members}",
              "Bots: #{botos} - (#{botpercent}%)",
              "Users: #{humans} - (#{humanpercent}%)"
            ].join("\n"), inline: true)
          end
  
          totalchans = server.channels.count
          textchans = server.text_channels.count
          voicechans = server.voice_channels.count
          categories = totalchans - textchans - voicechans
  
          e.add_field(name: 'Channel Count', value: [
            "Total: #{totalchans}",
            "Text: #{textchans}",
            "Voice: #{voicechans}",
            "Categories: #{categories}"
          ].join("\n"), inline: true)
  
          roles = []
          server.roles.each { |name| roles[roles.length] = name.name }
          roles -= ['@everyone']
  
          if roles.length > 50
            e.add_field(name: "Roles - #{server.roles.count}", value: "**(First 50)**: #{roles[0..49].join(', ')}", inline: true)
          else
            e.add_field(name: "Roles - #{server.roles.count}", value: roles.join(', ').to_s, inline: true)
          end
  
          e.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Server Created on')
          e.timestamp = server.creation_time
  
          e.color = '00FF00'
        end
      rescue Discordrb::Errors::NoPermission
        event.respond "SYSTEM ERRor, I CANNot SEND THE EMBED, EEEEE. Can I please have the 'Embed Links' permission? Thanks, appriciate ya."
      end
    end
  end
end
end