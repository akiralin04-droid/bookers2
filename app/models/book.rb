class Book < ApplicationRecord

  belongs_to :user

  # 1. タイトル: 空っぽNG
  validates :title, presence: true
  
  # 2. 感想: 空っぽNG、最大200文字
  validates :body, presence: true, length: { maximum: 200 }

 # 本はたくさんのいいねを持っている
  has_many :favorites, dependent: :destroy

  # 引数で渡されたユーザidがFavoritesテーブル内に存在するかどうかを調べるメソッド
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  has_many :book_comments, dependent: :destroy

end
