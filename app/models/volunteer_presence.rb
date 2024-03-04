class VolunteerPresence < ApplicationRecord
  belongs_to :participate_volunteer
  has_one :user, through: :participate_volunteer
  has_one :task, through: :participate_volunteer
  has_one :qr_code, through: :participate_volunteer, source: :qr_code_attachment
  has_one_attached :upload_proof, dependent: :destroy
  before_create :set_date_and_time

  scope :request_type, -> request_type { where(request_type: request_type) }
  scope :requst_status, -> (requst_status = 'pending') { where(requst_status: requst_status) }

  enum request_type: { upload_proof: 0, geo_location: 1, qr_code: 2 }
  enum requst_status: { pending: 0, approved: 1, rejected: 2 }
  
  def as_json(options = {})
    super(options).merge(
      participate_volunteer: participate_volunteer.as_json(except: [:created_at, :updated_at]),
      upload_proof_url: upload_proof.present? ? url_for(upload_proof) : ''
    )
  end

  def set_date_and_time
    self.date = Date.today.strftime("%d/%m/%Y")
    self.time = Time.now.strftime('%H:%M:%S')
  end
end
