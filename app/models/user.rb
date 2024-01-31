class User < ApplicationRecord
  has_one_attached :aadhar_card
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def self.authenticate!(email, password)
    user = find_by(email: email.downcase)
    user if user&.valid_password?(password)
  end
end
