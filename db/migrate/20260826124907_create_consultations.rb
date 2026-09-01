class CreateConsultations < ActiveRecord::Migration[8.1]
  def change
    create_table :consultations do |t|
      t.references :appointment,
                   null: false,
                   foreign_key: true,
                   index: { unique: true }

      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true

      t.text :symptoms
      t.text :diagnosis
      t.text :notes

      t.decimal :fee, precision: 10, scale: 2, null: false
      t.datetime :visited_at, null: false

      t.timestamps
    end
  end
end
