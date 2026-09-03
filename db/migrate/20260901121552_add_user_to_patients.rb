
class AddUserToPatients < ActiveRecord::Migration[8.1]
  def change
    unless foreign_key_exists?(:patients, :users)
      add_foreign_key :patients, :users
    end
  end
end