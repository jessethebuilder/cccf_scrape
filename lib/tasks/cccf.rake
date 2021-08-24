namespace :cccf do
  task scrape: :environment do
    RosterScraper.new.scrape
  end

  task send_new_bookings: :environment do
    User.wants_new_bookings.pluck(:id).each do |user_id|
      DailyMailer.new_bookings(user_id)
    end
  end
end
