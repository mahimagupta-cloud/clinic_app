class AddUserToDoctors < ActiveRecord::Migration[8.1]
  def change
    unless foreign_key_exists?(:doctors, :users)
      add_foreign_key :doctors, :users
    end
  end
end
