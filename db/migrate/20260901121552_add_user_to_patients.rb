
class AddUserToPatients < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :patients, :users
  end
end
