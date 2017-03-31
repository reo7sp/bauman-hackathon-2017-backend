class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: /@/
  validates :password_digest, presence: true

  has_secure_password
end
