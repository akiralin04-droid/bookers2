class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_many :books, dependent: :destroy

  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # 1. 名前: 一意性あり、2文字以上20文字以下
  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  
  # 2. 自己紹介: 最大50文字
  validates :introduction, length: { maximum: 50 }

  # ユーザーはたくさんのいいねを持っている
  has_many :favorites, dependent: :destroy

  has_many :book_comments, dependent: :destroy

  # 1. 自分がフォローしている人との関係（active_relationships）
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # その関係を通じて、「フォローしている人（followed）」の一覧を取得する設定
  has_many :followings, through: :active_relationships, source: :followed

  # 2. 自分をフォローしている人との関係（passive_relationships）
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # その関係を通じて、「フォロワー（follower）」の一覧を取得する設定
  has_many :followers, through: :passive_relationships, source: :follower

  # 3. 便利なメソッド作成（これをコントローラやビューで使います）
  
  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを外す
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをフォローしているかどうか判定する
  def following?(user)
    followings.include?(user)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end
  
end


