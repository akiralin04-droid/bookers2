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

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content + '%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%' + content)
    else
      Book.where('title LIKE ?', '%' + content + '%')
    end
  end

  # 並び替えの便利メソッド（スコープ）を定義
  scope :latest, -> { order(created_at: :desc) }
  scope :rating, -> { order(star: :desc) }
  
end
