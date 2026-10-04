class User < ApplicationRecord
  validates :name, presence: true
  has_one :user_authentication
end
