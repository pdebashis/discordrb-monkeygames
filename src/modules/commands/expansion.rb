module Bot
  module DiscordCommands
    # Inspect an expansion
    module Expansion
      extend Discordrb::Commands::CommandContainer
      command(:deck,
              description: 'shows details about a deck, and gives a sample',
              usage: "#{BOT.prefix}deck name",
              min_args: 1) do |event, *name|
        name = name.join(' ')
        expansion = Database::Expansion.find(Sequel.ilike(:name, name))
        # TODO: rework below to use #substitute
        unless expansion.nil?
          # fetch a sample
          sample = ''
          if expansion.answers.count.nonzero? && expansion.questions.count.nonzero?
            sample = expansion.questions.sample.text
            if sample.scan(/\_/).count.nonzero?
              sample.gsub!(/\_/) { "[#{expansion.answers.sample.text}]" }
            else
              sample << " [#{expansion.answers.sample.text}]"
            end
          elsif expansion.questions.count.nonzero?
            sample = expansion.questions.sample.text
          elsif expansion.answers.count.nonzero?
            sample = expansion.answers.sample.text
          end

          # send formatted message to discord
          event << "🗃 __Deck__: **#{expansion.name}**"
          event << '```cs'
          event << "authors: #{expansion.authors}"
          event << "cards: #{expansion.cards} "\
                   "(#{expansion.questions.count} questions,"\
                   " #{expansion.answers.count} answers)"
          event << "sample: \"#{sample}\""
          event << '```'
          return
        end
        'deck not found'
      end

      command(:decks,
              description: 'displays a list of expansions',
              usage: "#{BOT.prefix}decks") do |event|
        expansions = Database::Expansion.all
                                        .collect { |e| "`#{e.name} (#{e.cards})`" }
                                        .join('▫️')
        event << '**Available Decks**'
        event << expansions.to_s

        game = Database::Game.owner(event.user.id)
        unless game.nil?
          event << ''
          event << '**Decks in Your Game**'
          event << game.expansion_pools.collect { |e| "`#{e.expansion.name}`" }.join('▫️')
        end
      end
    end
  end
end