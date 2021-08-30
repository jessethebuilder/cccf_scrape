class Charge < ApplicationRecord
  belongs_to :booking
  belongs_to :bond, dependent: :destroy, required: false
end
