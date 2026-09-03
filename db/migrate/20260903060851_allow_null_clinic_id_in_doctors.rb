class AllowNullClinicIdInDoctors < ActiveRecord::Migration[8.1]
  def change
    change_column_null :doctors, :clinic_id, true
  end
end
