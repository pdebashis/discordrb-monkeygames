module Bot
  module Database
    class Trader < Sequel::Model
      one_to_one :traders
      one_to_many :trades

      def before_create
        super
        self.timestamp ||= Time.now
      end

      def after_create
        Discordrb::LOGGER.info("created trader #{inspect}")
      end

      def self.account(id)
        all.find { |t| t.discord_id == id }
      end

      def self.leaderboard(id)
        embed = Discordrb::Webhooks::Embed.new
        embed.title = 'Leaderboard'
        embed.color = 44783
        pl = all.sort_by(&:money).reverse.take(5)
        ladder = (1..pl.size).to_a.join "\n"
        embed.add_field name: '#', value: ladder, inline: true
        embed.add_field name: 'Name', value: pl.collect(&:nick_name).join("\n"), inline: true
        embed.add_field name: 'Balance', value: pl.collect(&:money).join("\n"), inline: true
        embed
      end

    end
  end
end