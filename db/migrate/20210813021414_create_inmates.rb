class CreateInmates < ActiveRecord::Migration[6.1]
  def change
    create_table :inmates do |t|
      t.string :name
      t.string :number
      t.string :age
      t.string :gender

      t.timestamps
    end
  end
end
