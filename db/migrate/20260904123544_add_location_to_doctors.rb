class AddLocationToDoctors < ActiveRecord::Migration[8.1]
  def change
    add_column :doctors, :location, :string
  end
end
