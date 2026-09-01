class PrescriptionItem < ApplicationRecord
  belongs_to :prescription

  validates :medicine_name, presence: true
  validates :dosage, presence: true
  validates :frequency, presence: true
  validates :duration, presence: true
end


