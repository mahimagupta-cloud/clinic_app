class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.datetime :scheduled_at, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :appointments,
              [ :doctor_id, :scheduled_at ],
              unique: true
  end
end
