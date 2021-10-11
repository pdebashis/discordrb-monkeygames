module Bot
    module DiscordCommands
    module Trade extend Discordrb::Commands::CommandContainer

    def self.invalid(event,args,size,command)
        if args.size != size
            event.channel.send_embed do |embed|
            embed.color = 'FF0000' 
            embed.description = "Invalid syntax! Please type :  `\\trade #{command}`" 
        end
        return true
        end
        false
    end

        tutorial = """
🗳 **__DuoLingo Challenge Details__** 
       
:writing_hand: **Available Commands**  
`\\duolingo help` - Display this help
`\\duolingo init username` - initialize your account
`\\duolingo daily` - get your daily points

`\\duolingo profile` - show your profile details
`\\duolingo top` - View the richest on the server
 
🔰 **Need help? Questions? Problems?**
Ask `codemonkey#2455`!
"""

command(:duolingo) do |event, *args|

    if args.empty? or args[0].include?("help") or args[0].eql?("h")
        event.channel.send_message tutorial
      end

  case args[0]
    when "init"
    return if invalid(event,args,2,"init <username>")
    lingo = Database::Lingo.account(event.user.id)

    url = "http://www.duolingo.com/users/#{args[1]}"
    unparsed_page = HTTParty.get(url)
    parsed_page ||= Nokogiri::HTML(unparsed_page.body)
  
    if (lingo)
      event.channel.send_embed do |embed|
        embed.color = 'FF0000'
        embed.description = "You have already initialized your account!"
      end
    else
      account = Database::Lingo.create(
        discord_id: event.user.id,
        discord_name: event.user.distinct,
        nick_name: event.user.display_name,
        server_id: event.server.id,
        dl_username: args[1]
      )
      event.channel.send_embed do |embed|
        embed.color = '56C114'
        embed.description = "Your account has been registered!"
      end
    end
    
    else
    event.channel.send_message "What do you mean by that?"
  end
end

end
end
end