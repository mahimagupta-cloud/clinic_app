class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  has_one :consultation, dependent: :destroy

  enum :status, {
    scheduled: 0,
    completed: 1,
    cancelled: 2,
    no_show: 3
  }

  validates :scheduled_at, presence: true
  validates :status, presence: true

  validate :scheduled_at_cannot_be_in_the_past, on: :create
  validate :doctor_must_be_available
  validate :cannot_cancel_past_appointment
  validate :valid_status_transition, on: :update

  private

  def scheduled_at_cannot_be_in_the_past
    return if scheduled_at.blank?

    if scheduled_at <= Time.current
      errors.add(:scheduled_at, "must be in the future")
    end
  end

  def doctor_must_be_available
    return if doctor.blank? || scheduled_at.blank?

    day = scheduled_at.wday
    time = scheduled_at.strftime("%H:%M:%S")

    available = doctor.doctor_availabilities.where(day_of_week: day).any? do |availability|
      time >= availability.start_time.strftime("%H:%M:%S") &&
        time <= availability.end_time.strftime("%H:%M:%S")
    end

    unless available
      errors.add(:scheduled_at, "doctor is not available at this time")
    end
  end

  def cannot_cancel_past_appointment
    return unless cancelled?

    if scheduled_at.present? && scheduled_at <= Time.current
      errors.add(:status, "past appointment cannot be cancelled")
    end
  end

  def valid_status_transition
    previous_status = status_in_database

    allowed_transitions = {
      "scheduled" => %w[completed cancelled no_show],
      "completed" => [],
      "cancelled" => [],
      "no_show" => []
    }

    return if previous_status == status
    return if allowed_transitions[previous_status]&.include?(status)

    errors.add(:status, "cannot be changed from #{previous_status} to #{status}")
  end
end
