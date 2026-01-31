class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # 1人が1つの投稿に対して、1回しかいいねできないようにする制限
  validates :user_id, uniqueness: { scope: :book_id }
end