module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module RemindMe
      extend Discordrb::Commands::CommandContainer
      # Creates a new game

      command(:remind_me, min_args: 1) do |event, interval|

        seconds = 0
        TOKENS = {
          "s" => (1),
          "m" => (60),
          "h" => (60 * 60),
          "d" => (60 * 60 * 24)
        }

        interval.downcase.scan(/(\d+)(\w)/).each do |amount, measure|
          seconds += amount.to_i * TOKENS[measure]
        end

        if seconds <= 0
          event << "Dont Break Me with invalid commands!"
          return
        end

        event.channel.send_message "What do you want to remind yourself in `#{interval}`?"

        discord_id = event.user.id
        discord_name = event.user.distinct

        msg_for_future=""

        event.user.await(:msg) do |msg_event|

          msg_for_future = msg_event.message.content
          
          curr = Time.now.to_i
          future = curr + seconds
          future_date = Time.at(future)

          reminder = Database::Reminder.create(
            discord_id: event.user.id,
            discord_name: event.user.distinct,
            message_content: msg_for_future,
            message_date: future_date
          )
          reminder.save

          msg_event.respond ("Ok Boss")
        end
        return
      end
    end
  end
end