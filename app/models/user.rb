class User < ApplicationRecord
  validates :first_name, presence: :true
  validates :last_name, presence: :true
  validates :email, presence: :true

  validates_confirmation_of :password, if: ->(user) { user.password.present? }
end