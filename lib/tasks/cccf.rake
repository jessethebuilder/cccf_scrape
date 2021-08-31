namespace :cccf do
  task scrape: :environment do
    RosterScraper.new.scrape
  end

  task send_new_bookings: :environment do
    User.wants_new_bookings.pluck(:id).each do |user_id|
      puts "Sending to User: #{user_id}" if Rails.env.development?
      DailyMailer.new_bookings(user_id).deliver_now
    end
  end
end
