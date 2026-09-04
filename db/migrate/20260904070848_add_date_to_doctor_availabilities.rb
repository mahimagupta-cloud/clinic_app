class AddDateToDoctorAvailabilities < ActiveRecord::Migration[8.1]
  def change
    add_column :doctor_availabilities, :date, :date
  end
end
