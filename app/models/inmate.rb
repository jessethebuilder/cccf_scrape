class Inmate < ApplicationRecord
  has_many :bookings, dependent: :destroy
end
