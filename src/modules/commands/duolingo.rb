module Bot
    module DiscordCommands
    module Lingo extend Discordrb::Commands::CommandContainer
      extend Lingorb

    def self.invalid(event,args,size,command)
        if args.size != size
            event.channel.send_embed do |embed|
            embed.color = 'FF0000' 
            embed.description = "Invalid syntax! Please type :  `\\duolingo #{command}`" 
        end
        return true
        end
        false
    end

    CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml'
    USERNAME=CONFIG.duolingouser
    KEY=CONFIG.duolingokey

    duolingo_client = Lingorb::Client.new(USERNAME,KEY)
    duolingo_client.login

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
        return "***:bird: :bird: :bird:***"
        return 
      end

  case args[0]
    when "init"
      return if invalid(event,args,2,"init <username>")
      lingo = Database::Lingo.account(event.user.id)

      user = duolingo_client.find_user args[1]
  
      if (lingo)
        event.channel.send_embed do |embed|
          embed.color = 'FF0000'
          embed.description = "You have already initialized your account!"
        end
      elsif(user.id.nil?)
        event.channel.send_embed do |embed|
          embed.color = 'FF0000'
          embed.description = "Username not found!"
        end
      else
        account = Database::Lingo.create(
        discord_id: event.user.id,
        discord_name: event.user.distinct,
        nick_name: event.user.display_name,
        server_id: event.server.id,
        dl_username: args[1],
        xp: user.xp)
        event.channel.send_embed do |embed|
        embed.color = '56C114'
        embed.description = "Your account has been registered! (ID: #{args[1]}})"
        end
      end
    when "profile"
      lingo = Database::Lingo.account(event.user.id)

      user = duolingo_client.find_user lingo.dl_username

      event.channel.send_embed do |embed|
        embed.colour = 0xff8040
        embed.add_field name: "**#{lingo.dl_username}** (`#{user.learning_language}`)\n", value: "**XP**    : #{lingo.xp}\n**Points**    : #{lingo.points}\n**Streak**: #{user.streak}\n"
      end
    else
    event.channel.send_message "What do you mean by that?"
    end
  end
end

end
end