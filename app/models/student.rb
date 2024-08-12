class Student < ApplicationRecord
  has_many :installment_plans
  has_many :payments
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
end