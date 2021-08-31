class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.datetime :date
      t.datetime :release_date
      t.datetime :scheduled_release_date
      t.string :facility
      t.string :origin
      t.float :total_bond_amount
      t.float :total_bail_amount
      t.string :number
      t.references :inmate, null: false

      t.timestamps
    end
  end
end
