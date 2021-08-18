class CreateCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :charges do |t|
      t.string :description
      t.datetime :offense_date
      t.string :docket_number
      t.string :disposition
      t.date :disposition_date
      t.string :arrested_by
      t.string :commit
      t.string :court
      t.references :booking, null: false, foreign_key: true
      t.references :bond, foreign_key: true

      t.timestamps
    end
  end
end
