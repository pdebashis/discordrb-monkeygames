module Bot
    module DiscordCommands
    module Bookworm extend Discordrb::Commands::CommandContainer

        tutorial = """
🗳 **__BookWorm Challenge Details__** 
       
:writing_hand: **Available Commands**  
`\\bookworm help` - Returns commands list
`\\bookworm init` - Initialize your account in book club
`\\bookworm daily` - get points daily
`\\bookworm list` - Returns a list of all the books you've read.
`\\bookworm top` - Lists the top 5 book club members
`\\bookworm search <bookname>` - Search for a book (searches wiki or google)
`\\bookworm set <bookname>` - Search and set a book as your current reading book
`\\bookworm finished <bookname>` - Let Bot know that you've finished the current book

 
🔰 **Need help? Questions? Problems?**
Ask `codemonkey#2455`!
"""
command(:bookworm) do |event, *args|

    if args.empty? or args[0].include?("help") or args[0].eql?("h")
        event.channel.send_message tutorial
        return "***:books: :books: :books:***"
    end

    case args[0]
      when "init"
        event.channel.send_message "Work in Progress"
      when "daily"
        event.channel.send_message "Work in Progress"
      when "list"
        event.channel.send_message "Work in Progress"
      when "top"
        event.channel.send_message "Work in Progress"
      when "search"
        event.channel.send_message "Work in Progress"
      when "set"
        event.channel.send_message "Work in Progress"
      when "finished"
        event.channel.send_message "Work in Progress"
      else
        event.channel.send_message "What do you mean by that, Sir?"
    end
end
   
end
end
end