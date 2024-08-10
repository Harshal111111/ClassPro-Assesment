class CreateInstallmentPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :installment_plans do |t|
      t.decimal :total_amount
      t.integer :number_of_installments
      t.text :installments
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
