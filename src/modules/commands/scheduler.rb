module Bot
  module Scheduler
    def self.run(bot)
      scheduler = Rufus::Scheduler.new
      
    
      scheduler.cron '0 10 * * *' do
      #scheduler.every '5s' do
        send_today=Database::Reminder.where{Sequel[:message_date] < Date.today + 1}
        data={}
        send_today.each do |pm_user|
          data['id']=pm_user.discord_id
          Discordrb::User.new(data,BOT).pm("Hi I am a bot. You have a message for yourself => " + pm_user.message_content)
          pm_user.destroy
        end
      end
    end
  end
end