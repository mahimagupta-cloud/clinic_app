class Payment < ApplicationRecord
  belongs_to :appointment

  enum :status, {
    pending: 0,
    completed: 1,
    failed: 2
  }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :appointment, presence: true
  validates :appointment_id, uniqueness: true
end