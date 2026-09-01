class CreateDoctorAvailabilities < ActiveRecord::Migration[8.1]
  def change
    create_table :doctor_availabilities do |t|
      t.references :doctor, null: false, foreign_key: true
      t.integer :day_of_week
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
