class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: Settings.name.maximum}
  validates :email, format: {with: VALID_EMAIL_REGEX},
    presence: true, uniqueness: {case_sensitive: false},
    length: {maximum: Settings.email.maximum}
  validates :password, presence: true,
   length: {minimum: Settings.password.minimum}

  before_save :downcase_email

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end
  end
end
