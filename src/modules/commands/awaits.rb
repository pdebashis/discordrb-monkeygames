module Bot::DiscordCommands
  module Awaits
    extend Discordrb::Commands::CommandContainer
    
    command(:guess, help_available: false) do |event, *code|
      magic = rand(1..10)
      event.user.await(:guess) do |guess_event|
        guess = guess_event.message.content.to_i
        if guess == magic
          guess_event.respond 'you win!'
        else
          guess_event.respond(guess > magic ? 'too high' : 'too low')
          false         # This returns `false`, which will not destroy the await so we can reply again
        end
      end
      event.respond 'Guess a number between 1 and 10..'
    end
  end
end