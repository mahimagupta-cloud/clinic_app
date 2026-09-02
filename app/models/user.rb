class User < ApplicationRecord
  enum :role, {
    patient: 0,
    admin: 1,
    doctor: 2
  }

  has_one :patient, dependent: :destroy
  has_one :doctor, dependent: :destroy
  after_initialize :set_default_role, if: :new_record?

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  private

  def set_default_role
    self.role ||= :patient
  end
end
