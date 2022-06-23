class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  validates :content, length: {minimum: 1, maximum: 100}, presence: true
end
