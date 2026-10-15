class User < ApplicationRecord
  validates :name, presence: true
  has_one :user_authentication
  has_many :tasks
  has_many :favorite_tasks
  has_many :follows
  has_many :target_users, through: :follows, source: :target_user
end