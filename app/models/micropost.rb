class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 200 }
  validates :title, presence: true, length: { maximum: 20 }
  validates :tag, presence: true
end
