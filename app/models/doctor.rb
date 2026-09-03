class Doctor < ApplicationRecord
  belongs_to :user, optional: true
  has_many :appointments, dependent: :destroy
  has_many :patients, through: :appointments
  has_many :doctor_availabilities, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :consultations, dependent: :destroy
  validates :name, presence: true
  validates :specialization, presence: true
  validates :consultation_fee, presence: true
  belongs_to :clinic, optional: true
end
