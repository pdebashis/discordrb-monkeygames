module Bot
  module Database
    class Trader < Sequel::Model
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

      def total_balance
        account_bal = money
        other_bal = 0
        trades.each do |hold|
          other_bal += hold.buyprice + hold.pnl
        end
        account_bal + other_bal
      end

      def self.leaderboard(id)
        embed = Discordrb::Webhooks::Embed.new
        embed.title = 'Leaderboard'
        embed.color = 44783
        users = {}
        all.each do |p|
          users[p] = p.total_balance
        end

        final = users.sort_by {|_key, value| value}.last(5).reverse

        ladder = (1..final.size).to_a.join "\n"
        embed.add_field name: '#', value: ladder, inline: true
        embed.add_field name: 'Name', value: final.collect{ |t| t[0].nick_name }.join("\n"), inline: true
        embed.add_field name: 'Balance', value: final.collect(&:last).join("\n"), inline: true
        embed
      end
    end
  end
end

module Bot
  module Database
    class Trade < Sequel::Model
      many_to_one :traders

      def before_create
        super
        self.timestamp ||= Time.now
      end
    end
  end
end