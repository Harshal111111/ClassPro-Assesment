class Payment < ApplicationRecord
  belongs_to :student
  belongs_to :installment_plan
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :installment_index, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end