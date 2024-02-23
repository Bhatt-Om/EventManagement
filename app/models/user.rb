class User < ApplicationRecord
  has_many :participate_volunteers, dependent: :destroy
  has_many :tasks, through: :participate_volunteers
  has_many :volunteer_presences, through: :participate_volunteers
  has_one_attached :aadhar_card, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def self.authenticate!(email, password)
    user = find_by(email: email.downcase)
    user if user&.valid_password?(password)
  end

  def is_admin?
    role == 'admin'
  end

  def as_json(options = {})
    super(options).merge(
        avatar_url: avatar.present? ? url_for(avatar) : '',
        aadhar_card_url: aadhar_card.present? ? url_for(aadhar_card) : ''
      )
  end
end
