module Bot::DiscordCommands
  module Help extend Discordrb::Commands::CommandContainer

    CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml'
    APIKEY=CONFIG.finnhub_token
    
      
    FinnhubRuby.configure do |config|
      config.api_key['api_key'] = APIKEY
    end

    fc = FinnhubRuby::DefaultApi.new

    def self.get_stock_price(fc, symbol)
      fc.quote(symbol).pc
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
`\\trade balance` - List the balance (accepts user argument)
`\\trade list` - List the current trades (accepts user argument)
`\\trade leaderboard` - View the richest on the server
 
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
          event.channel.send_message "Stop. Feature not implemented."
        when "daily"
          event.channel.send_message "Stop. Feature not implemented."
        when "search"
          event.channel.send_message "Stop. Feature not implemented."
        when "show"
          return if invalid(event,args,2,"show <symbol>")
          price = get_stock_price(fc, args[1])
          if price.zero?
            event.channel.send_embed do |embed|
              embed.color = 'FF0000'
              embed.description = "An error occurred (the request to the service may have been unsuccessful)"
            end
          else
            event.channel.send_embed do |embed|
              embed.color = '008CFF'
              embed.description = "#{price}"
            end
          end
        when "buy"
          event.channel.send_message "Stop. Feature not implemented."
        when "sell"
          event.channel.send_message "Stop. Feature not implemented."
        when "close"
          event.channel.send_message "Stop. Feature not implemented."
        when "balance"
          event.channel.send_message "Stop. Feature not implemented."
        when "list"
          event.channel.send_message "Stop. Feature not implemented."
        when "leaderboard"
          event.channel.send_message "Stop. Feature not implemented."
        else
          "What?"
      end
      return
    end
  end
end