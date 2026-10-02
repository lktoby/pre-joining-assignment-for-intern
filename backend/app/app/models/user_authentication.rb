class UserAuthentication < ApplicationRecord
  has_secure_password
  validates :identifier, length: { in: 8..32 }, format: { with: /\A[a-zA-Z0-9_]+\z/ }, uniqueness: true
  validates :password, length: { in: 8..32 }, format: { with: /\A[a-zA-Z0-9_@-]+\z/ }
  self.primary_key = :identifier
  belongs_to :user
end
