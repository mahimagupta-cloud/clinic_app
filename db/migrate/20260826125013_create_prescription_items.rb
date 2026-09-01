class CreatePrescriptionItems < ActiveRecord::Migration[8.1]
  def change
    create_table :prescription_items do |t|
      t.references :prescription, null: false, foreign_key: true

      t.string :medicine_name, null: false
      t.string :dosage
      t.string :frequency
      t.string :duration
      t.text :instructions

      t.timestamps
    end
  end
end
