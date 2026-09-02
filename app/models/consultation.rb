class Consultation < ApplicationRecord
  belongs_to :appointment
  belongs_to :doctor
  belongs_to :patient

  has_one :prescription, dependent: :destroy
end
