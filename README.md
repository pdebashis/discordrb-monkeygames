# gemstone

This is created using a template for a modular [Discord](https://discordapp.com/) chat bot using z64's [gemstone](https://github.com/z64/gemstone) which uses meew0's [discordrb](https://github.com/meew0/discordrb).

## Configuring and running your bot

Make a copy of data/config-template.yaml and rename it to `config.yaml` *exactly*.

Fill out each field provided to set up a minimal discord bot, with a few commands and an event to get you started.

To run your bot, open your terminal and run `rake` in the top level folder of your bot. 

```Example Run Script
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
