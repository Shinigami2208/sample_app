class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validates.user.VALID_EMAIL_REGEX

  validates :name, presence: true, length: {maximum: Settings.validates.user.max_length_name}
  validates :email, presence: true, length: {maximum: Settings.validates.user.max_length_email},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.validates.user.min_length_password}

  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
