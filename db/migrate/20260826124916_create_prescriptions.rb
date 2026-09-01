



class CreatePrescriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :prescriptions do |t|
      t.references :consultation,
                   null: false,
                   foreign_key: true,
                   index: { unique: true }

      t.timestamps
    end
  end
end
