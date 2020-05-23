module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module Game
      extend Discordrb::Commands::CommandContainer
      # Creates a new game
      command(:cah) do |event|
        if Database::Game.owner(event.user.id)
          'You can only host one game at a time. '\
          'Use `\end` to end an active game that you host.'
        else
          # Create channels
          game_id = (Database::DB[:sqlite_sequence].where(name: 'games')&.first&.[](:seq) || 0) + 1
          # channels = {
          #   text: event.server.create_channel("game_#{game_id}", 0),
          #   voice: event.server.create_channel("game_#{game_id}", 2)
          # }

          # permissions = Discordrb::Permissions.new
          # permissions.can_read_messages = true
          # permissions.can_connect       = true

          # channels.each do |_, c|
          #   c.define_overwrite(event.bot.profile, permissions, 0)
          #   c.define_overwrite(event.user, permissions, 0)
          #   c.define_overwrite(event.server.everyone_role, 0, permissions)
          # end

          # Create game
          game = Database::Game.create(
            text_channel_id:  event.channel.id,
            # voice_channel_id: channels[:voice].id,
            server_id: event.server.id,
            max_points: CONFIG.max_points
          )

          # Create player
          owner = Database::Player.create(
            discord_id: event.user.id,
            discord_name: event.user.distinct,
            game: game
          )

          # Assign game owner
          game.owner = owner
          game.save

          tutorial = """
   🗳 **__How to Play__**

  :writing_hand: **Available Commands**  
  `games` - show the ongoing game names
  `invite` - invite a member to the game
  `decks` - show the available decks
  `deck` - sample a deck
  `add` - add a deck to your game
  `remove` - remove a deck to your game
  `score` - current score of the game
  `start` - start the game
  `end` - end the game

  🙇 **As a player..**
  1. Each round, I will direct-message you your cards.
  2. Reply in our DM with `pick (a number)` to pick a card that you think fits the question best!
  If a question has multiple answeusingrs, say `pick (number)` multiple times in the order you want
  your cards to appear!
  3. Wait for the Judge to pick the winning card
  
  👑 **As the Judge..**
  1. Wait for other players to submit their choices.
  I'll let you know when we've got all the cards we need!
  2. Pick the card you think should win by saying `pick (a number)` in this channel!
  
  🔰 **Need help? Questions? Problems?**
  Ask `codemonkey#2455`!

  """

          event.channel.send_message tutorial
          "***Have fun!***"
        end
      end

      # Displays active games and their owners
      command(:games) do |event|
        next 'No active games..' if Database::Game.active.empty?

        games = Database::Game.active.collect do |g|
          "`#{g.owner.discord_name} (#{g.server.name} #{g.name}, #{g.players.count} players)`"
        end.join(' ')

        "**Active Games:** #{games}"
      end

      # Invites users to game
      command(:invite) do |event|
        next 'Mention a user to invite!' if event.message.mentions.empty?

        game = Database::Game.owner(event.user.id)
        unless game.nil?
          event.message.mentions.each do |u|
            u = u.on event.server
            if game.players.any? { |p| p.discord_id == u.id }
              event << "`#{u.distinct}` is already part of your game!"
            else
              next event << "Couldn't add #{u.display_name}.. (max players: 10)" if game.players.count >= 10
              game.add_player discord_id: u.id, discord_name: u.distinct, discord_nick: u.display_name

              # TODO: Create Permissions template for this
              # permissions = Discordrb::Permissions.new
              # permissions.can_read_messages = true
              # permissions.can_connect       = true
              # [game.text_channel, game.voice_channel].each do |c|
              #   c.define_overwrite(u, permissions, 0)
              # end
              event << "Added #{u.distinct} to your game!"
            end
          end
          return
        end
        'You aren\'t hosting any active games.'
      end

      # Adds an expansion to the game
      command(:add, min_args: 1) do |event, *names|
        game = Database::Game.owner(event.user.id)

        next 'You aren\'t hosting any active games.' if game.nil?

        next 'You can\'t modify your expansions after a game has been started!' if game.started

        names = names.join(' ')
        if names.casecmp('all').zero?
          Database::Expansion.all.each do |e|
            game.add_expansion_pool expansion: e
          end
          event << 'Added all available expansions to your current game.'
          return
        end

        names.split(',').map(&:strip).each do |name|
          expansion = Database::Expansion.find(Sequel.ilike(:name, name))
          unless expansion.nil?
            if game.expansion_pools.find { |e| e.expansion == expansion }
              event << "Expansion `#{expansion.name}` is already in your game."
            else
              game.add_expansion_pool expansion: expansion
              event << "Added expansion: `#{expansion.name}`"
            end
          else
            event << "Could not find expansion: `#{name}`"
          end
        end
        nil
      end

      # Removes an expansion from the game
      command(:remove, min_args: 1) do |event, *names|
        game = Database::Game.owner(event.user.id)

        next 'You aren\'t hosting any active games.' if game.nil?

        next 'You can\'t modify your expanions after a game has been started!' if game.started

        names = names.join(' ')
        if names.casecmp('all').zero?
          game.remove_all_expansion_pools
          event << 'Removed all expansions from your current game.'
          return
        end

        names.split(',').map(&:strip).each do |name|
          expansion = Database::Expansion.find(Sequel.ilike(:name, name))
          pool = game.expansion_pools.find { |e| e.expansion == expansion }
          if pool
            event << "Removed expansion: `#{expansion.name}`"
            pool.destroy
          else
            event << "Expansion not found: `#{expansion.name}`"
          end
        end
        nil
      end

      command(:tts, description: 'toggles the bot\'s usage of tts when displaying the winning card') do |event|
        game = Database::Game.owner(event.user.id)
        next '❎ You don\'t own any active games..' if game.nil?

        game.update use_tts: !game.use_tts

        "**TTS** #{game.use_tts ? '👍' : '👎'}"
      end

      command(:score, description: 'displays your current score') do |event|
        game = Database::Game.owner(event.user.id)
        next '❎ You don\'t own any active games..' if game.nil?

        player = game.players.find { |p| p.discord_id == event.user.id }
        "Your score in `#{game.name}` is: `#{player.score}`"
      end

      # Starts a game
      command(:start) do |event|
        game = Database::Game.owner(event.user.id)

        unless game.nil?
          next 'Your game has already started!' if game.started

          next 'You must have at least one deck added to your game to start a game!' if game.expansion_pools.empty?

          #next "You must have at least `#{CONFIG.min_players}` players to start a game!" if game.players.count < CONFIG.min_players

          unless game.enough_cards?
            event << 'Your game doesn\'t have enough cards '\
                     'to complete a full game! Please add more '\
                     'decks with `add`. Use `decks` '\
                     'to see a list of what you can pick from.'
            return
          end

          event << "The game `##{game.id}` has started!**"
          game.start!
          return
        end
        'You aren\'t hosting any active games.'
      end

      # Ends a game
      command(:end) do |event|
        game = Database::Game.find text_channel_id: event.channel.id
        next 'This isn\'t a channel with an active game..' if game.nil?
        game.end! if game.owner.discord_id == event.user.id
        nil
      end
    end
  end
end