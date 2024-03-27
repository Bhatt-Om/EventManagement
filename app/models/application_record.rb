class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include Rails.application.routes.url_helpers
  include CalculateDistance
end
