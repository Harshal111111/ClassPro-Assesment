class InstallmentPlan < ApplicationRecord
  belongs_to :student
  has_many :payments

  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :number_of_installments, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :installments_sum_equals_total_amount, if: :installments_set?

  before_validation :set_initial_installments, on: :create

  def installments
    super&.map(&:to_f) || []
  end

  def remaining_balance
    total_amount - payments.sum(:amount)
  end

  private

  def set_initial_installments
    return if total_amount.blank? || number_of_installments.blank?
    installment_amount = (total_amount.to_f / number_of_installments).round(2)
    self.installments = Array.new(number_of_installments, installment_amount.to_s)
  end

  def installments_sum_equals_total_amount
    return if installments.sum.round(2) == total_amount.to_f.round(2)
    errors.add(:installments, "sum must equal the total amount")
  end

  def installments_set?
    installments.present?
  end
end