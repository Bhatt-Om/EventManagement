class Task < ApplicationRecord
  has_many :participate_volunteers, dependent: :destroy
  has_many :users, through: :participate_volunteers
  has_one_attached :event_poster, dependent: :destroy

  def as_json(options = {})
    super(options).merge(
      event_poster_url: event_poster.present? ? url_for(event_poster) : ''
    )
  end
end
