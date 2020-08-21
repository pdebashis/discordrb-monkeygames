module Bot
  module Scheduler
    def self.run(bot)
      scheduler = Rufus::Scheduler.new
      
    
      scheduler.every('5s', overlap: false) do
        send_today=Database::Reminder.where(:message_date => (Date.today))
        data={}
        # 391862190732476420
        send_today.each do |pm_user|
          data['id']=pm_user.discord_id
          Discordrb::User.new(data,BOT).pm("Hi I am a bot. You have a message for yourself => " + pm_user.message_content)
          pm_user.destroy
        end
      end
    end
  end
end