class UpdatePaymentsTable < ActiveRecord::Migration[7.0]
  def change
    change_table :payments do |t|
      t.change :amount, :decimal, precision: 10, scale: 2
    end
  end
end
