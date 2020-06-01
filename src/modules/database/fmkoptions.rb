module Bot
  module Database
    # An expansion
    class FmkOption < Sequel::Model
    	many_to_one :fmk_tag

      # Log creation
      def after_create
        Discordrb::LOGGER.info("created tag #{inspect}")
      end
    
      def update_f! (serial)
        update(f1: Sequel.expr(1) + :f1) if serial == 1
        update(f2: Sequel.expr(1) + :f2) if serial == 2
        update(f3: Sequel.expr(1) + :f3) if serial == 3
      end
    
      def update_m! (serial)
        update(m1: Sequel.+(:m1,1)) if serial == 1
        update(m2: Sequel.+(:m2,1)) if serial == 2
        update(m3: Sequel.+(:m3,1)) if serial == 3
      end
    
      def update_k! (serial)
        update(k1: Sequel.+(:k1,1)) if serial == 1
        update(k2: Sequel.+(:k2,1)) if serial == 2
        update(k3: Sequel.+(:k3,1)) if serial == 3
      end

      def get_first_person
        if (f1 > m1 and f1 > k1)
          "fuck"
        elsif m1 > k1
            "marry"
        else
            "kill"
        end
      end

      def get_sec_person
        if (f2 > m2 and f2 > k2)
          "fuck"
        elsif m2 > k2
            "marry"
        else
            "kill"
        end
      end

      def get_third_person
        if (f3 > m3 and f3 > k3)
          "fuck"
        elsif m3 > k3
            "marry"
        else
            "kill"
        end
      end

      def stats
        embed = Discordrb::Webhooks::Embed.new
        embed.title = 'Overall Stats'
        embed.color = 44783
        
        a = get_first_person
        b = get_sec_person
        c = get_third_person
        
        pref = [a,b,c]

        ladder = names.split(",").join("\n")

        embed.add_field name: '#', value: ladder, inline: true
        embed.add_field name: 'Preference', value: pref.join("\n"), inline: true
        embed
      end

    end
  end
end