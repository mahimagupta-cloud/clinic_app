class CreateDoctors < ActiveRecord::Migration[8.1]
  def change
    create_table :doctors do |t|
      t.references :clinic, null: false, foreign_key: true
      t.string :name
      t.string :specialization
      t.integer :experience
      t.text :bio
      t.decimal :consultation_fee

      t.timestamps
    end
  end
end
