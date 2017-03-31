class User < ApplicationRecord
  has_many :storage_files

  validates :email, presence: true, uniqueness: true, format: /@/
  validates :password_digest, presence: true

  has_secure_password
end
