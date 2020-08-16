module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module NotesToFuture
      extend Discordrb::Commands::CommandContainer
      # Creates a new game

      command(:notes) do |event|

        info = """
           🗳 **:writing_hand: __Write Notes to yourself in the future__**

           Write a message to yourself and you will receive it in your email on a future date.

           If your email is not added, use the below command :

           \\my_email

           If you have a message for yourself, specify using the below : 

           \\my_msg <number of days in future>

           And then type your message here...


          🔰 **Need help? Questions? Problems?**
          Ask `codemonkey#2455`!

          """
        event.channel.send_message info
      end

      command(:my_email, min_args: 1) do |event, *name|
        discord_id = event.user.id
        discord_name = event.user.distinct

        #record_in_db = Database::Notes.email(event.user.id)
        if record_in_db
          "**Updated record in database...**"
        else
          "**Email Address saved for user...** #{discord_name}"
        end
      end

      command(:my_msg, min_args: 1, max_args: 1) do |event, num|
        discord_id = event.user.id
        discord_name = event.user.distinct

        owner = Database::Emails.email(event.user.id)
        
        if owner
          event << "**What is your message to yourself in the future...**"
          event.user.await(:days) do |days_event|
            
          end

          event << "**How many days in the future do you want to recieve the message?...**"
          event.user.await(:msg_content) do |msg_event|
          
          note = Database::Notes.create(
            msg: msg_content
            create_date:
            send_date: 
          )

          # Assign game owner
          note.owner = owner
          note.save
        else
          "**I dont have your address in the database...**"
          return
        end
      end

   end
  end
end