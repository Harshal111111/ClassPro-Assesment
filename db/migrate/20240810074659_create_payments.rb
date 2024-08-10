class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.references :student, null: false, foreign_key: true
      t.references :installment_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
