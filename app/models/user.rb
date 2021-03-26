class User < ApplicationRecord
  validates :first_name, presence: :true
  validates :last_name, presence: :true
  validates :email, presence: :true

  validates_confirmation_of :password, if: ->(user) { user.password.present? }
  has_secure_password(validations: false)

  def to_token
    {
      id: self.id,
      email: self.email,
      full_name: "#{self.first_name} #{self.last_name}"
    }
  end
end