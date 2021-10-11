module Bot
    module Database
      class Lingo < Sequel::Model
  
        def before_create
          super
          self.timestamp ||= Time.now
        end
  
        def after_create
          Discordrb::LOGGER.info("created duolingo user #{inspect}")
        end
  
        def self.account(id)
          all.find { |t| t.discord_id == id }
        end
  
        def total_balance
        #   account_bal = money
        #   other_bal = 0
        #   trades.each do |hold|
        #     other_bal += hold.buyprice + hold.pnl
        #   end
        #   account_bal + other_bal
        end
  
        def self.leaderboard(id)
        #   embed = Discordrb::Webhooks::Embed.new
        #   embed.title = 'Leaderboard'
        #   embed.color = 44783
        #   users = {}
        #   all.each do |p|
        #     users[p] = p.total_balance
        #   end
  
        #   final = users.sort_by {|_key, value| value}.last(10).reverse
  
        #   embed.add_field name: 'Name', value: final.collect.with_index{ |t,i| "#{i+1}. `#{t[0].nick_name}` " + "(#{t.last.round(2)})" }.join("\n"), inline: true
        #   embed
        end
      end
    end
  end
