module Bot
  module Scheduler
    def self.run(bot)
      scheduler = Rufus::Scheduler.new
  
      puts "Scheduler is running"
      scheduler.every '1m' do
        send_today=Database::Reminder.where{Sequel[:message_date] < Time.now}
        puts "send today -> #{send_today}"
        data={}
        send_today.each do |pm_user|
          data['id']=pm_user.discord_id
          Discordrb::User.new(data,BOT).pm(":speech_balloon: | You have a message for yourself from the past \n`" + pm_user.message_content + "`")
          pm_user.destroy
        end
      end
    end
  end
end