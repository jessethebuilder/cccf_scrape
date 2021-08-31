class DailyMailer < ApplicationMailer
  def new_bookings(user_id)
    @user = User.find(user_id)

    end_time = Time.parse('9:00am').in_time_zone('Pacific Time (US & Canada)').utc
    start_time = end_time - 1.day + 1.second

    @bookings = Booking.where('created_at < ?', end_time)
                       .where('created_at > ?', start_time)

    mail(
      to: @user.email,
      subject: "New CCCF Bookings for #{Date.today}",
    )
  end
end
