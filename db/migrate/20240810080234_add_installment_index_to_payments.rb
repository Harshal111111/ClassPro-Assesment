class AddInstallmentIndexToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :installment_index, :integer
  end
end
