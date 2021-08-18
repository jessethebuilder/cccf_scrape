class Booking < ApplicationRecord
  belongs_to :inmate
  has_many :charges, dependent: :destroy
end
