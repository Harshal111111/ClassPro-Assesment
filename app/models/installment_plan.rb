class InstallmentPlan < ApplicationRecord
  belongs_to :student
  has_many :payments

  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :number_of_installments, presence: true, numericality: { greater_than: 0 }

  before_create :set_initial_installments

  def installments
    super.map(&:to_f)
  end

  private

  def set_initial_installments
    installment_amount = (total_amount.to_f / number_of_installments).round(2)
    self.installments = Array.new(number_of_installments, installment_amount.to_s)
  end
end