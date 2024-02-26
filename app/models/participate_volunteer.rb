class ParticipateVolunteer < ApplicationRecord
  belongs_to :task
  belongs_to :user
  has_one :volunteer_presence, dependent: :destroy
  has_one_attached :qr_code, dependent: :destroy
  enum participate_request: { pending: 0, approved: 1, rejected: 2 }

  scope :admin, -> { all }
  scope :user, -> user_id { where(user_id: user_id) }
  scope :request_type, -> request_type { where(participate_request: request_type) }

  def as_json(options = {})
    super(options).merge(
      user: lambda { |u| u.slice('id', 'name', 'email', 'role', 'mobile_number') }.call(user),
      task: lambda { |u| u.slice('id', 'event_name', 'event_location', 'google_link', 'date', 'time', 'points') }.call(task),
      qr_code_url: qr_code.present? ? url_for(qr_code) : ''
    )
  end
  
  def generate_qr_code
    qr_code = generate_qr_code_for
    begin
      filename = "qr_code_#{SecureRandom.hex}.png"
      self.qr_code.attach(io: StringIO.new(qr_code.to_s), filename: filename, content_type: 'image/png')
    rescue StandardError => e
      Rails.logger.error("Error attaching QR code for ParticipateVolunteer #{self.id}: #{e.message}")
    end
  end

  def generate_qr_code_for
    qrcode = RQRCode::QRCode.new(self.id.to_s)
    
    qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120,
    )
  end
end
