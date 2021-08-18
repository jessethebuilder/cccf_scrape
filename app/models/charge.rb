class Charge < ApplicationRecord
  belongs_to :booking, dependent: :destroy
  belongs_to :bond, dependent: :destroy
end
