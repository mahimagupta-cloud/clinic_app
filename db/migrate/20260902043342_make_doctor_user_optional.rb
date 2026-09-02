class MakeDoctorUserOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :doctors, :user_id, true
  end
end
