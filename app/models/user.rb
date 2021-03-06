class User < ApplicationRecord
  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i,
              message: 'Invalid email format'
            }

  scope :wants_new_bookings, -> { where(send_new_bookings: true) }
end
