class FavoriteTask < ApplicationRecord
  validates :user_id, presence: true, uniqueness: { scope: :task_id }
  validates :task_id, presence: true, uniqueness: { scope: :user_id }
  belongs_to :user
  belongs_to :task
end
