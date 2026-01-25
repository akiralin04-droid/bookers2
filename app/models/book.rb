class Book < ApplicationRecord

  belongs_to :user

  # 1. タイトル: 空っぽNG
  validates :title, presence: true
  
  # 2. 感想: 空っぽNG、最大200文字
  validates :body, presence: true, length: { maximum: 200 }

end
