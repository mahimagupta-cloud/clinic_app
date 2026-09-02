class AddUserToDoctors < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :doctors, :users
  end
end
