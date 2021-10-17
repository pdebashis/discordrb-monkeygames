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

    def self.no_account(event,linguist)
      return false if linguist
      event.channel.send_embed do |embed|
        embed.color = 'FF0000'
        embed.description = "You have not initialized an Account!"
      end
      return true
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
      elsif(user.nil?)
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
      return if no_account(event,lingo)

      user = duolingo_client.find_user lingo.dl_username

      event.channel.send_embed do |embed|
        embed.colour = 0xff8040
        embed.add_field name: "**#{lingo.nick_name}**", value: 
                "**Language** : #{user.learning_language}
                **XP**    : #{lingo.xp}
                **Points**    : #{lingo.points}
                **Streak**: #{user.streak} days"
      end
    when "daily"
      linguist = Database::Lingo.account(event.user.id)
      return if no_account(event,linguist)

      user = duolingo_client.find_user linguist.dl_username

      prev_xp = linguist.xp
      dailytime = linguist.daily_time
      now = Time.now.to_i
      delay = 43200 - (now - dailytime)

      if delay <= 60
        new_xp = user.xp
        prev_point = linguist.points
        diff = new_xp - prev_xp
        if diff < 1
          event.channel.send_embed do |embed|
            embed.color = 'FF0000'
            embed.description = "You have not made any progress!!"
          end
        else
          points = diff > 30 ? 2 : 1
          new_point = prev_point + points
          linguist.update(xp: new_xp)
          linguist.update(points: new_point)
          linguist.update(daily_time: now)

          event.channel.start_typing
          sleep 1

          event.channel.send_embed do |embed|
            embed.color = '56C114'
            embed.description = "Your Submission is successful (XP : +#{diff},Score : +#{points})!!"
          end
        end
      else
        x = delay / 3600
        y = (delay - x*3600) / 60
        event.channel.send_embed do |embed|
          embed.color = '56C114'
          embed.description = "You can try again in `#{x}h#{y}m`!!"
        end
      end
    else
    event.channel.send_message "What do you mean by that?"
    end
  end
end

end
end