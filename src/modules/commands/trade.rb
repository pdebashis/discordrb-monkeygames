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

    def self.no_account(event,trader)
      return false if trader
      event.channel.send_embed do |embed|
        embed.color = 'FF0000'
        embed.description = "You have not initialized an Account!"
      end
      return true
    end

    tutorial = """
🗳 **__How to Trade__** 
       
:writing_hand: **Available Commands**  
`\\trade help` - Display this help
`\\trade init` - initialize an account with start amount 10,000
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
          trader = Database::Trader.account(event.user.id)
          initBal = 10000
        
          if (trader)
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
            event.channel.send_embed do |embed|
              embed.color = '56C114'
              embed.description = "Your account has been created!"
            end
          end
        when "daily"
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader)

          money = trader.money
          dailytime = trader.daily_time
          now = Time.now.to_i
          delay = 86400 - (now - dailytime)

          if delay < 0
            bonus = rand(100..300)
            new_money = money + bonus
            trader.update(money: new_money)
            trader.update(daily_time: now)

            event.channel.start_typing
            sleep 1

            event.channel.send_embed do |embed|
              embed.color = '56C114'
              embed.description = "You have received :moneybag: #{bonus} in your account!!"
            end
          else
            x = delay / 3600
            y = (delay - x*3600) / 60
            event.channel.send_embed do |embed|
              embed.color = '56C114'
              embed.description = "Please don't bother me again for `#{x}h#{y}m`!!"
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
            event.channel.start_typing
            sleep 1
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
            event.channel.start_typing
            sleep 1
            event.channel.send_embed do |embed|
              embed.color = '008CFF'
              embed.add_field name: "#{quote[:exchange]}", value: "#{quote[:name]}"
              embed.add_field name: "Price", value: ":dollar: #{get_price(quote[:close])}"
            end
          end
        when "buy","sell"
          return if invalid(event,args,3,"buy/sell <symbol> <amount>")
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader)

          if trader.trades.size > 9
            event.channel.send_embed do |embed|
              embed.color = 'FF0000'
              embed.description = "Order Denied! (too many open positions in account)"
            end
            return
          end

          symb = args[1]
          amount = args[2].to_i
          unless symb.match(/^([A-Za-z\/])+$/) and amount.to_s.match(/^(\d)+$/)
            return event.channel.send_message "Your command broke me!!!"
          end
          money = trader.money
          if money < amount
            event.channel.send_embed do |embed|
              embed.color = 'FF0000'
              embed.description = "Payment Refused! (You don't have enough funds)"
            end
            return
          end
          quote = td_client.quote(symbol: symb).parsed_body
          if quote[:exchange].nil?
            event.channel.send_embed do |embed|
              embed.color = 'FF0000'
              embed.description = "An error occurred (The symbol didn't fetch any stocks)"
            end
          else
            price = get_price(quote[:close]).to_f
            vol = amount.to_f / price
            trade_entry = Database::Trade.create(
              trader_id: trader.id,
              type: args[0],
              symbol: symb,
              vol: vol,
              buyprice: amount.to_f
            )

            trader.add_trade trade_entry

            trader.update(money: money-amount)
            event.channel.send_embed do |embed|
              embed.color = '56C114'
              embed.title = "Order Executed!"
              embed.description = "__Debit Amount__: #{amount}"
            end
          end
        when "close"
          return if invalid(event,args,2,"close <id>")
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader)
          return event.channel.send_message "You don't own any share!" if trader.trades.size.zero?

          id = args[1].to_i
          t = trader.trades.find{ |t| t.id == id }

          account_balance = trader.money
          selling_price = t.buyprice + t.pnl

          t.destroy
          trader.update(money: account_balance + selling_price)

          event.channel.send_embed do |embed|
            embed.color = '56C114'
            embed.title = "Order Executed!"
            embed.description = "__Credit Amount__: #{selling_price}"
          end  

        when "closeall"
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader)
          return event.channel.send_message "You don't own any share!" if trader.trades.size.zero?

          account_balance = trader.money
          selling_price = 0
          trader.trades.each do |t|
            selling_price += t.buyprice + t.pnl
          end

          trader.trades.each do |t|
            t.destroy
          end
          trader.update(money: account_balance + selling_price)

          event.channel.send_embed do |embed|
            embed.color = '56C114'
            embed.title = "Order Executed!"
            embed.description = "__Credit Amount__: #{selling_price}"
          end  

        when "balance","bal"
          event.channel.start_typing
          sleep 1

          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader)

          selling_price = 0
          pnl_price = 0
          trader.trades.each do |t|
            selling_price += t.buyprice
            pnl_price += t.pnl
          end

          event.channel.send_embed do |embed|
            embed.color = '008CFF'
            embed.add_field name: "Account Balance", value: ":dollar: #{trader.money}"
            embed.add_field name: "Current Trades", value: ":dollar: #{selling_price} (Profit: #{pnl_price})"
          end
        when "list"
          trader = Database::Trader.account(event.user.id)
          return if no_account(event,trader)
          return event.channel.send_message "You don't own any share!" if trader.trades.size.zero?

          event.channel.start_typing
          sleep 1

          embed = Discordrb::Webhooks::Embed.new
          embed.title = "Trades of #{trader.nick_name}"
          embed.color = '008CFF'

          trader.trades.each do |t|
            embed.add_field name: "#{t.type.upcase} - #{t.symbol} (ID: #{t.id})", value: "__Volume__: #{t.vol}\n __P/L__: #{t.pnl}\n __Order Placed__: #{t.timestamp}"
          end

          event.channel.send_message(
            "",
            false,
            embed
          )
        when "top"
          event.channel.start_typing
          sleep 1
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