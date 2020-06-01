module Bot
  module Database
    # An expansion
    class FmkTag < Sequel::Model
    	one_to_many :fmk_options

      # Log creation
      def after_create
        Discordrb::LOGGER.info("created tag #{inspect}")
      end
    end
  end
end
