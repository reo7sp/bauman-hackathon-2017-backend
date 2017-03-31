class Session < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :token, presence: true, uniqueness: true
end
