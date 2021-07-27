module Bot
    module DiscordCommands
      # Commands to manage game creation and flow
      module Poll
        extend Discordrb::Commands::CommandContainer
        # Creates a new game
        command(:poll,
              description: 'create a poll for taking feedback',
              usage: "#{BOT.prefix}poll {type} {ques} {option1} {option2} ...",
              min_args: 4,
              aliases: [:nist_poll]) do |event, *args|

            REACTIONS = {
                'colors'         => %w[🔴 🟢 🟡 🔵 🟠 🟣  🟤 ⚫ ⚪ 🟥 🟫 🟧 🟪 🟨 🟦 🟩 ⬛ ⬜ 🔶 🔺],
                'shapes'         => %w[🟢 🔶 🟨 🔺🚁 🚀 🚢 🛹 🚲 🛴 🛵 🚑 🚒 🦽 🚗 🚓 🚌 🚚 🚜 🚅],
                'numbers'        => %w[0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 🇦 🇧 🇨 🇩 🇪 🇫 🇬 🇭 🇮],
                'letters'        => %w[🇦 🇧 🇨 🇩 🇪 🇫 🇬 🇭 🇮 🇯 🇰 🇱 🇲 🇳 🇴 🇵 🇶 🇷 🇸 🇹],
                'food'           => %w[🍎 🍍 🍇 🥐 🥗 🥪 🍕 🥓 🍜 🥘 🍧 🍩 🍰 🍬 🍭 ☕ 🧃 🍵 🍾 🍸],
                'faces'          => %w[😄 😋 😎 😂 🥰 😎 🤔 🙄 😑 🤨 😮 😴 😛 😤 🤑 😭 😨 🥵 🥶 😷]
            }

            all_args = args.join(" ").split(/[{}]+/).reject{ |x| x.strip.empty? }

            type = all_args.first
            ques = all_args[1]
            options = all_args[2..-1]
            raise Exception.new("You must specify a maximum of twenty options in order to create the poll.") if options.length > 20

            event.message.delete

            layout = REACTIONS[type]
            raise Exception.new("This type of reaction is invalid") if layout.nil?

            emojis = layout[0..(options.length - 1)]

            description = ''
            options.each.with_index do |option, index|
                description << "#{emojis[index]} `#{option}`\n"
            end

            message = event.channel.send_embed do |embed|
                embed.title = ":bar_chart: Poll : #{ques}"
                embed.description = description.chomp
                embed.colour = 0xff8040
                embed.author = Discordrb::Webhooks::EmbedAuthor.new(
                    name: event.author.display_name,
                    icon_url: event.author.avatar_url
                )
            end

            emojis.each do |emoji|
                message.react(emoji)
            end

            return

        end
      end
    end
  end