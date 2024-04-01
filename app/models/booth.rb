class Booth < ApplicationRecord
  belongs_to :user, optional: true
  has_many :booth_attandances, dependent: :destroy
  has_one_attached :qr_code, dependent: :destroy

  after_create :generate_qr_code

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

  def as_json(options = {})
    super(options).merge(
      qr_code: qr_code.present? ? url_for(qr_code) : ''
    )
  end
end
