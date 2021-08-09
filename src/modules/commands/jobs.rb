module Bot
  module DiscordCommands
    # Commands to manage game creation and flow
    module Jobs extend Discordrb::Commands::CommandContainer

        def self.li_scraper(keyword,location)
            res=""
            url = "https://www.linkedin.com/jobs/search?keywords=#{keyword}&location=#{location}"
            unparsed_page = HTTParty.get(url)
            parsed_page ||= Nokogiri::HTML(unparsed_page.body)
            # Getting Result 1,000+ Results for "user entered location"
            total_jobs = parsed_page.css('span.results-context-header__job-count').text
            query_result_info = parsed_page.css('span.results-context-header__query-search').text
            new_jobs = parsed_page.css('span.results-context-header__new-jobs').text
            res += total_jobs + ' ' + query_result_info + ' ' + new_jobs.strip
            res += "\n------------------------------------\n"

            # Getting Job Info and storing in a Array
            jobs = Array.new
            job_listings = parsed_page.xpath("//div[@class='base-card base-card--link base-search-card base-search-card--link job-search-card']")

            job_listings.each do |job_listing|
                job = {
                    title: job_listing.css('h3').text.strip,
                    company:job_listing.css('h4').text.strip,
                    location:job_listing.css('span.job-search-card__location').text.strip,
                    url: job_listing.css('a')[0].attributes['href'].value,
                    time: job_listing.css('time.job-search-card__listdate--new').text.strip
                }

                next if job[:time].empty?
                jobs << job
                next if jobs.size > 5
                res += "Role: [#{job[:title]}](#{job[:url]})\n"
                res += "Company: `#{job[:company]}`\n"
                res += "Location: #{job[:location]}\n"
                res += "#{job[:time]}\n"
                res += "------------------------------------\n"
            end
            res
        end

        command(:jobs,
              description: 'search job portals for a job posting',
              usage: "#{BOT.prefix}jobs location keyword1 keyword2 ...",
              min_args: 2) do |event, *args|
        
            location = args.first
            keywords = CGI.escape args[1..-1].join(" ")

            output = li_scraper(keywords,location)

            event.channel.send_embed do |embed|
              embed.description = output
            end
        end


    end
  end
end