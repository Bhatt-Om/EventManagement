class Booth < ApplicationRecord
  belongs_to :user, optional: true
end
