class ParticipateVolunteer < ApplicationRecord
  belongs_to :task
  belongs_to :user
  enum participate_request: { pending: 0, approved: 1, rejected: 2 }

  def as_json(options = {})
    super(options).merge(
      user: lambda { |u| u.slice('id', 'name', 'email', 'role') }.call(user),
      task: task
    )
  end
end
