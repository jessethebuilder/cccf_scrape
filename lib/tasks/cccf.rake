namespace :cccf do
  task scrape: :environment do
    RosterScraper.new.scrape
  end
end
