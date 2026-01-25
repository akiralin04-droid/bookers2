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

end

