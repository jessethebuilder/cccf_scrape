class DailyMailer < ApplicationMailer
  def new_bookings(user_id)
    @user = User.find(user_id)

    mail(
      to: @user.email,
      subject: "New CCCF Bookings for #{Date.today}",
    )
  end
end
