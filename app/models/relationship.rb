class Relationship < ApplicationRecord
  # class_name: "User" と書くことで、FollowerテーブルではなくUserテーブルを参照させます
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end