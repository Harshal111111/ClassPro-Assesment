class Student < ApplicationRecord
  has_many :installment_plans
  has_many :payments
  validates :name, presence: true
end