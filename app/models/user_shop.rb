class UserShop < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :shop, foreign_key: 'shops_id'
end
