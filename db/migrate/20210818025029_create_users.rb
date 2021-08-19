class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :send_new_bookings, default: true

      t.timestamps
    end
  end
end
