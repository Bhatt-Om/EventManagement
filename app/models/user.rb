class User < ApplicationRecord
  belongs_to :role
  has_many :participate_volunteers, dependent: :destroy
  has_many :tasks, through: :participate_volunteers
  has_many :volunteer_presences, through: :participate_volunteers
  has_one_attached :aadhar_card, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  after_initialize do |user|
    self.role_id ||= 2
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def self.authenticate!(email, credential, credential_type)
    user = find_by(email: email)

    if user && user.valid_credential?(credential, credential_type)
      user
    else
      nil
    end
  end

  def valid_credential?(credential, credential_type)
    case credential_type.to_sym
    when :password
      valid_password?(credential)
    when :otp
      self.otp == credential ? true : false
    else
      false
    end
  end

  def is_admin?
    role.role_name == 'admin'
  end

  def as_json(options = {})
    super(options).merge(
        role: user.role? ? role.role_name : '',
        avatar_url: avatar.present? ? url_for(avatar) : '',
        aadhar_card_url: aadhar_card.present? ? url_for(aadhar_card) : ''
      )
  end
end
