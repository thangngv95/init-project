class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost

  default_scope -> {order(created_at: :desc)}
  validates :content, presence: true, length: {maximum: 50}
end
