# MONKEY GAMES

This is a [Discord](https://discordapp.com/) chat bot interactive game using z64's [gemstone](https://github.com/z64/gemstone) template.

## Configuring and running your bot

Make a copy of data/config-template.yaml and rename it to `config.yaml` *exactly*.

Fill out each field provided to set up a minimal discord bot, with a few commands and an event to get you started.

To run your bot, open your terminal and run `rake` or `ruby run.rb` in the top level folder of your bot. 

```Example Run Script
pid=`ps -ef | grep run.rb | grep -v grep | awk '{print $2}'`
kill $pid
while true
do
  echo "updating from git.."
  git pull

  echo "running rubocop.."
  rubocop src

  echo "updating documentation.."
  yardoc src

  echo "starting bot.."
  rake
done
```

## Generating docs

Install YARD.

`gem install yard`

In the top level folder, run:

`yardoc`

Your docs will be generated in a new folder, `doc/`.

## Checking style with rubocop

Install rubocop.

`gem install rubocop`

In the top level folder, run:

`rubocop`

## Support
