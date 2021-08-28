module Bot
  module DiscordCommands
  module Trade extend Discordrb::Commands::CommandContainer

    CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml'
    APIKEY=CONFIG.twelvedata_token
    
      

    td_client = TwelvedataRuby.client(apikey: APIKEY, connect_timeout: 300)

    def self.get_price(price)
      price.to_f
    end

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

    def self.no_account(event,trader,msg)
      return false if trader
      msg.delete if msg
      event.channel.send_embed do |embed|
        embed.color = 'FF0000'
        embed.description = "You have not initialized an Account!"
      end
      return true
    end


    tutorial = """
🗳 **__How to Trade__** *(Under Development)*  
       
:writing_hand: **Available Commands**  
`\\trade help` - Display this help
`\\trade init` - initialize an account with start amount X
`\\trade daily` - get free resources
   
`\\trade search` - get symbol for a company
`\\trade show` -  get details about a symbol
`\\trade buy/sell` - Create a trade by deducting amount and get trade ID
`\\trade close` - Close a trade and credit the account
`\\trade closeall` - Close all trades and credit the account
`\\trade balance` - List the balance (accepts user argument)
`\\trade list` - List the current trades (accepts user argument)
`\\trade top` - View the richest on the server
 
🔰 **Need help? Questions? Problems?**
Ask `codemonkey#2455`!
"""
    command(:trade) do |event, *args|
      if args.empty? or args[0].include?("help") or args[0].eql?("h")
        event.channel.send_message tutorial
        return "***:rocket: :rocket: :rocket:***"
      end

      case args[0]
        when "init"
          msgBot = event.channel.send_embed do |embed|
            embed.color = 'FF8400'
            embed.description = "Creating account..."
          end
          trader = Database::Trader.account(event.user.id)
          initBal = 10000
        
          if (trader)
            msgBot.delete
            event.channel.send_embed do |embed|
              embed.color = 'FF0000'
              embed.description = "You have already initialized your account!"
            end
          else
            account = Database::Trader.create(
              discord_id: event.user.id,
              discord_name: event.user.distinct,
              nick_name: event.user.display_name,
              server_id: event.server.id
            )
            msgBot.delete
            event.channel.send_embed do |embed|
              embed.color = '56C114'
              embed.description = "Your account has been created!"
            end
          end
        when "daily"
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader,nil)

          money = trader.money
          dailytime = trader.daily_time
          now = Time.now.to_i
          delay = 86400 - (now - dailytime)

          if delay < 0
            new_money = money + 500
            trader.update(money: new_money)
            trader.update(daily_time: now)
            event.channel.send_embed do |embed|
              embed.color = '56C114'
              embed.description = "You have received :moneybag: 500 in your account!!"
            end
          else
            x = delay / 3600
            y = (delay - x*3600) / 60
            event.channel.send_embed do |embed|
              embed.color = '56C114'
              embed.description = "You are eligible for daily bonus after `#{x}h#{y}m`!!"
            end
          end
        when "search"
          return if invalid(event,args,2,"search <symbol>")
          quote = td_client.symbol_search(symbol: args[1]).parsed_body
          if quote[:data].nil?
            event.channel.send_embed do |embed|
              embed.color = 'FF0000'
              embed.description = "An error occurred (the request to the service may have been unsuccessful)"
            end
          else
            size = quote[:data].size
            desc = "\n"
            quote[:data].each_with_index do |x,i|
              desc = desc + x[:instrument_name] + "(`#{x[:exchange]}`:`#{x[:symbol]}`)\n" if i < 10
            end
            event.channel.send_embed do |embed|
              embed.color = '008CFF'
              embed.description = "#{size} matches found"
              embed.add_field name: "Showing Top Search Results", value: desc
            end
          end
        when "show"
          return if invalid(event,args,2,"show <symbol>")
          quote = td_client.quote(symbol: args[1]).parsed_body
          if quote[:exchange].nil?
            event.channel.send_embed do |embed|
              embed.color = 'FF0000'
              embed.description = "An error occurred (the request to the service may have been unsuccessful)"
            end
          else
            event.channel.send_embed do |embed|
              embed.color = '008CFF'
              embed.add_field name: "#{quote[:exchange]}", value: "#{quote[:name]}"
              embed.add_field name: "Price", value: ":dollar: #{get_price(quote[:previous_close])}"
            end
          end
        when "buy"
          return if invalid(event,args,3,"buy <symbol> <amount>")
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader,nil)

          event.channel.send_message "Stop. Feature not implemented."
        when "sell"
          return if invalid(event,args,3,"sell <symbol> <amount>")
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader,nil)
          event.channel.send_message "Stop. Feature not implemented."
        when "close"
          return if invalid(event,args,3,"close <id>")
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader,nil)
          event.channel.send_message "Stop. Feature not implemented."
        when "closeall"
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader,nil)
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader,nil)
          event.channel.send_message "Stop. Feature not implemented."
        when "balance","bal"
          msgBot = event.channel.send_embed do |embed|
            embed.color = 'FF8400'
            embed.description = "Fetching account balance..."
          end
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader,msgBot)
          msgBot.delete
          event.channel.send_embed do |embed|
            embed.color = '008CFF'
            embed.add_field name: "Balance", value: ":dollar: #{trader.money}"
            embed.author = Discordrb::Webhooks::EmbedAuthor.new(
                    name: event.author.display_name,
                    icon_url: event.author.avatar_url
                )
          end
        when "list"
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader,nil)
          event.channel.send_message "Stop. Feature not implemented."
        when "top"
          event.channel.send_message(
          "",
          false,
          Database::Trader.leaderboard(event.author.id)
        )
        else
          event.channel.send_message "What do you mean by that?"
      end
      return
    end
  end
end
end