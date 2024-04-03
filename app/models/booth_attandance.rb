class BoothAttandance < ApplicationRecord
  belongs_to :booth
  validates :user_lat, presence: true
  validates :user_lot, presence: true
  has_one_attached :image, dependent: :destroy
  enum request_type: { qr_code: 0,  location: 1}
  enum request_stats: { pending: 0, approved: 1, rejected: 2 }
  
  scope :booth_id, -> booth_id { where(booth_id: booth_id) }
  scope :request_type, -> request_type { where(request_type: request_type) }
  scope :request_stats, -> request_stats { where(request_stats: request_stats) }

  def as_json(options = {})
    super(options).merge(
      booth:  lambda { |u| u.slice('booth_name', 'booth_number') }.call(booth),
      user: booth.user.present? ?  lambda { |u| u.slice('name', 'email') }.call(booth.user) : '',
      image_url: image.present? ? url_for(image) : ''
    )
  end
end
  