class ChangeInstallmentsToJsonInInstallmentPlans < ActiveRecord::Migration[7.0]
  def up
    change_column :installment_plans, :installments, :json, using: 'installments::json'
  end

  def down
    change_column :installment_plans, :installments, :text
  end
end
