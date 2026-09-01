class Patient < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :doctors, through: :appointments
  has_many :reviews, dependent: :destroy
  has_many :consultations, dependent: :destroy

  validates :name, presence: true
  validates :phone, presence: true
end
