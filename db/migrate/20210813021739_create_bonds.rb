class CreateBonds < ActiveRecord::Migration[6.1]
  def change
    create_table :bonds do |t|
      t.string :number
      t.string :bond_type
      t.float :amount

      t.timestamps
    end
  end
end
