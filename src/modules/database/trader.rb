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

    end
  end
end