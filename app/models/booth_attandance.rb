class BoothAttandance < ApplicationRecord
  belongs_to :booth
  validates :user_lat, presence: true
  validates :user_lot, presence: true
  has_one_attached :image, dependent: :destroy

  enum request_type: { qr_code: 0,  location: 1}
  enum request_stats: { pending: 0, approved: 1, rejected: 2 }
end
