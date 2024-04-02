class Task < ApplicationRecord
  has_many :participate_volunteers, dependent: :destroy
  has_many :users, through: :participate_volunteers
  has_one_attached :event_poster, dependent: :destroy
  validates :task_lat, presence: true
  validates :task_lon, presence: true
  before_destroy :remove_event_point

  def remove_event_point
    
  end

  def as_json(options = {})
    super(options).merge(
      event_poster_url: event_poster.present? ? url_for(event_poster) : ''
    )
  end
end
