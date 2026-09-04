class MakeDoctorUserOptional < ActiveRecord::Migration[8.1]
  def change
    unless !column_exists?(:doctors, :user_id)
      change_column_null :doctors, :user_id, true
    end
  end
end
