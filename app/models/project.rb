class Project < ApplicationRecord

  # Relationships

  belongs_to :user, optional: true

  # Validations

  validates :name, :initial_fee, :price, presence: true
  
end
