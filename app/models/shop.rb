class Shop < ApplicationRecord
  has_many :user_shops
  has_many :users, through: :user_shops, foreign_key: 'shops_id'
end
