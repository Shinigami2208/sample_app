class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  VALID_EMAIL_REGEX = Settings.validates.user.VALID_EMAIL_REGEX

  attr_accessor :remember_token

  validates :name, presence: true,
            length: {maximum: Settings.validates.user.max_length_name}
  validates :email, presence: true,
            length: {maximum: Settings.validates.user.max_length_email},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true,
            length: {minimum: Settings.validates.user.min_length_password},
            allow_nil: true

  has_secure_password

  before_save :downcase_email

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost
      cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticate? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
