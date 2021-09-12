module Bot
  module Scheduler

    Songs = {
      "shuffle" => [],
    "codemonkey" => ["doom_time_to_paint_the_battlefield_red.mp3"],
    "anantyash9" => ["pudge_make_room_for_pudge.mp3"],
    "sagarsethy" => ["zeus_make_your_offerrings.mp3"],
    "AmarS1993" => ["juggernaut_ability_bladefury.mp3"],
    "Nemesis_23" => ["silencer_comes_to_war.mp3"],
    "dharamx" => ["who_calls_the_crystal_maiden.mp3"]
  }

  def self.get_price(price)
    price.to_f
  end

    def self.run(bot)
      scheduler = Rufus::Scheduler.new
      $lastPlayed = Time.now - 50
  
      scheduler.every '2m' do
        send_today=Database::Reminder.where{Sequel[:message_date] < Time.now}
        data={}
        send_today.each do |pm_user|
          data['id']=pm_user.discord_id
          Discordrb::User.new(data,BOT).pm(":speech_balloon: | You have a message for yourself from the past \n`" + pm_user.message_content + "`")
          pm_user.destroy
        end 
      end

      scheduler.every '2h' do
        config = OpenStruct.new YAML.load_file 'data/config.yaml'
        td_client = TwelvedataRuby.client(apikey: config.twelvedata_token, connect_timeout: 300)
        trades=Database::Trade.all
        trades.each do |t|
          sym = t.symbol
          quote = td_client.quote(symbol: sym).parsed_body
          next if quote[:exchange].nil?
          price = get_price(quote[:close])
          curr_price = t.vol * price
          pnl = t.type == 'buy'? curr_price - t.buyprice : t.buyprice - curr_price
          t.update(pnl: pnl)
          sleep 12
        end
      end

      Bot::BOT.voice_state_update(from: not!(["Monkey Games","Rythm"])) do |event|
        voice = Bot::BOT.voice(event.server)
        event.user.extend(UserTimeout)
        # Minute delay for the individual user switching, 15 seconds for any user, to prevent spamming
        if (!event.user.lastPlayed or Time.now - event.user.lastPlayed > 60) and Time.now - $lastPlayed > 15 and event.old_channel.nil? and !voice.nil?
          $lastPlayed = Time.now
          event.user.lastPlayed = Time.now
          voice = Bot::BOT.voice_connect(event.channel)
          if Songs[event.user.name]
            voice.play_file("sounds/#{Songs[event.user.name].sample}")
          else
            voice.play_file("sounds/#{Songs['shuffle'].sample}")
          end
        end
      end
    end
  end
end
