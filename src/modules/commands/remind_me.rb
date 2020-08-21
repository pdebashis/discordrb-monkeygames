module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module RemindMe
      extend Discordrb::Commands::CommandContainer
      # Creates a new game

      command(:remind_me, min_args: 1) do |event, days|

        days_in_future=days.to_i
        if days_in_future <= 0 or days_in_future > 1000
          event << "Dont Break Me with invalid commands!"
          return
        end

        event.channel.send_message "What do you want to remind yourself in #{days} days?"

        discord_id = event.user.id
        discord_name = event.user.distinct

        msg_for_future=""

        event.user.await(:msg) do |msg_event|

          msg_for_future = msg_event.message.content
          

          curr = Time.now.to_i
          future = curr + days_in_future * 86400
          future_date = Time.at(future).strftime("%Y-%m-%d")
          future_date_store = Time.strptime(future_date,"%Y-%m-%d")

          reminder = Database::Reminder.create(
            discord_id: event.user.id,
            discord_name: event.user.distinct,
            message_content: msg_for_future,
            message_date: future_date_store
          )
          reminder.save

          msg_event.respond ("Ok")
        end
        return
      end
    end
  end
end