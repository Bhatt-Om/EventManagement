class Role < ApplicationRecord
  validates :role_name, presence: true, uniqueness: true
  has_many :users
  before_destroy :set_default_role

  def set_default_role
    Role.transaction do
      volunteer_role = Role.find_or_create_by(role_name: 'volunteer')
      users.update_all(role_id: volunteer_role.id)
    end
  rescue StandardError => e
    Rails.logger.error "Error setting default role for users: #{e.message}"
  end
end
