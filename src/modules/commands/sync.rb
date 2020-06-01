module Bot
  module DiscordCommands
    # Syncs expansions with db
    module Sync
      extend Discordrb::Commands::CommandContainer
      command(:sync_cah) do |event|
        event.respond 'syncronizing cards of humanity, this may take a moment..'

        # load from dah-cards submodule
        Dir.glob('data/dah-cards/*.yaml').each do |f|
          data = YAML.load_file(f)

          # find existing expansion, otherwise create a new one
          expansion = Database::Expansion.find(name: data['expansion'])
          if expansion.nil?
            expansion = Database::Expansion.create(name: data['expansion'])
            if data['authors']
              expansion.update(authors: data['authors'].join(', '))
            else
              expansion.update(authors: 'online sourced')
            end
          end

          # wipe existing cards
          expansion.questions.map(&:destroy) unless expansion.questions.count.zero?
          expansion.answers.map(&:destroy) unless expansion.answers.count.zero?

          # restock questions
          data['questions'].uniq.each do |c|
            answers = c.scan(/\_/).count.zero? ? 1 : c.scan(/\_/).count
            Database::Question.create(
              text: c,
              answers: answers,
              expansion: expansion
            )
          end

          # restock answers
          data['answers'].uniq.each do |c|
            Database::Answer.create(
              text: c,
              expansion: expansion
            )
          end
        end
        'sync complete'
      end

      command(:sync_fmk) do |event|
        event.respond 'syncronizing fuck,marry,kill data with server, this may take a moment..'
        Dir.glob('data/fmk-cards/*.yaml').each do |f|
          data = YAML.load_file(f)

          

          data.each do |x|
            tag = x.first
            fmk_tag = Database::FmkTag.find(name: tag)
            
            if fmk_tag.nil?
              fmk_tag = Database::FmkTag.create(name: tag)
            end

            x.last.each do |options|
              
              exist_option = Database::FmkOption.find(names: options)

              unless exist_option
                Database::FmkOption.create(
                  names: options,
                  fmk_tag: fmk_tag
                )
              end
            end

          end
        end
        'sync complete'
      end

    end
  end
end