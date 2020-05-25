module Bot
  module Database
    # An expansion
    class FmkOption < Sequel::Model

      # Log creation
      def after_create
        Discordrb::LOGGER.info("created options #{inspect}")
      end

    end
  end
end
