module Bot::DiscordCommands
  module Info
    extend Discordrb::Commands::CommandContainer
	  
	  command(:nist_stats) do |event|
		members_count = event.channel.server.member_count
        bots = event.channel.server.bot_members
		non_bots = event.channel.server.non_bot_members
		
		bots_count = bots.count
		non_bots_count = non_bots.count

		users_nicks = non_bots.map(&:display_name)
		batchwise = users_nicks.select do |usr| 
			/ 20[0-9][0-9]/ =~ usr
        end

		batchless = users_nicks.reject do |usr| 
			/ 20[0-9][0-9]/ =~ usr
        end

		result = {}

        batchwise.each do |usr|
          batch = usr[-4..-1]
          if result[batch]
            result[batch] << usr
          else
            result[batch] = [usr]
          end
        end

		print_matrix = ""

		result.keys.sort.each do |batch|
			print_matrix << "#{batch} :point_right: #{result[batch].count}\n"
        end

		event.channel.send_embed do |embed|
		  embed.colour = 0xff8040
		  embed.add_field(name: 'Member Count', value: members_count, inline: true)
		  embed.add_field name: 'Detailed Statistics', value: "**Users**   : #{non_bots_count}\n**Bots** : #{bots_count}\n**Batchless Members Count** : #{batchless.count}\n **Batchwise Members Count**\n\n #{print_matrix}\n"
		  embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Server Created on')
          embed.timestamp = event.server.creation_time
		end
	  end

	command(:nist_others) do |event|
		users_nicks = event.channel.server.non_bot_members.map(&:display_name)
		batchless = users_nicks.reject do |usr| 
			/ 20[0-9][0-9]/ =~ usr
        end
		event.channel.send_message "#{batchless}"
	end

	command(:nist_export) do |event,batchquery|
		members = event.channel.server.non_bot_members
		output = "nickname,username,batch\n"
		members.each do |member|
			nick=member.display_name
			usern=member.username	
			if nick =~ / 20[0-9][0-9]/
				batch = nick[-4..-1] 
			else
				batch = "unknown"
			end
			output+="#{nick},#{usern},#{batch}\n"
		end

		unless batchquery.nil?
		    unless batchquery =~/20[0-9][0-9]/
				event.channel.send_message "Something wrong in your command..."
				raise "Command not parsed"
			end 
		    members = output.split("\n")
			new_output = ""
			members.each do |member|
				new_output += "#{member}\n" if member.split(",").last == batchquery
			end
			output = new_output
		end
	    event.channel.send_message "Generating CSV..."
		begin
			o_fp = File.new( "/tmp/members.csv","w+")
			o_fp.write(output)
			o_fp.close
		    event.channel.send_file File.open('/tmp/members.csv', 'r')
		rescue
			raise "Unable to create output file"
		    event.channel.send_message "Oops, it didnt work..."
		end
  	end

	command(:batch,min_args: 1) do |event,batchquery|
        members = event.channel.server.non_bot_members
        output = "nickname,batch\n"
        members.each do |member|
            nick=member.display_name
                if nick =~ / 20[0-9][0-9]/
                    batch = nick[-4..-1]
                else
                    batch = "unknown"
                end
                	output+="#{nick},#{batch}\n"
                end
                unless batchquery =~ /20[0-9][0-9]/
                    event.channel.send_message "Something wrong in your command..."
                    raise "Command not parsed"
                end
                event.channel.send_message "Your request is in process..."
                members = output.split("\n")
                    new_output = ""
                    members.each do |member|
                        nname=member.split(",").first
                        new_output += "#{nname}\n" if member.split(",").last == batchquery
                    end
                begin
                    o_fp = File.new( "/tmp/members.csv","w+")
                    o_fp.write(new_output)
                    o_fp.close
                    event.author.send_file File.open('/tmp/members.csv', 'r')
                rescue
                    raise "Unable to create output file"
                    event.channel.send_message "Oops, it didnt work..."
                end
        end
		
		command(:book_leaderboard) do |event|
		     event.channel.send_embed do |embed|
		         embed.colour = 0xff8040
		         embed.add_field name: "**Book Challenge LeaderBoard**", value: "**1. Bandana 2006**   - The Everyday hero Manifesto **(10)**\n**2. Debashis 2016**    - Move First. Think Later **(7)**\n**3. Suprav 2002** - O'Reilly's Introducing MLOps **(2)**\n**4. Prateek 2016** - The secret **(2)**\n**5. Pooja 2016** - The Tatas **(1)**\n"
		        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'http://clipart-library.com/newhp/book_12142c-300x290.jpg')
		     end
		  end
		
		  command(:lang_leaderboard) do |event|
		    event.channel.send_embed do |embed|
		        embed.colour = 0xff8040
		        embed.add_field name: "**Duolingo LeaderBoard**", value:  "**1. Bandana 2006** - Spanish **(16)**\n**2. Sunil Hotta 2016** - Spanish **(16)**\n**3. Debasis 2016** - Mandarin **(15)**\n**4. Subhashree 2021** - German **(15)**\n**5. Prateek 2016**  - German **(14)**\n**6. Soumya 2007** - Spanish **(12)**\n"
		       embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://sm.pcmag.com/t/pcmag_in/review/d/duolingo/duolingo_9mrz.3840.jpg')
		    end
		end
		
		  command(:fit_leaderboard) do |event|
		     event.channel.send_embed do |embed|
		         embed.colour = 0xff8040
		         embed.add_field name:  "**Health & Fitness LeaderBoard**", value:  "**1. Aishwarya Routray 2016** (8)\n**2. Bandana 2006**    (8)\n**3. Sunil Hotta 2016**    (6)\n**4. Roma Mishra 2007**    (5)\n**5. Pragyan Dalai 2016**  (3)\n**6. Subhadarshi Mishra 2015**     (3)\n**7. Subhashree Mishra 2021**      (2)\n**8. Vicky Jami 2001**     (2)\n**9. Suprav 2002** (1)"
		         embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTW5bsT9PCYDvcfbeXyUP5EtKM-GR5rCURsYQ&usqp=CAU')
		     end
		  end
  end
end