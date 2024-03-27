module CalculateDistance
  extend ActiveSupport::Concern

  # Define Earth's radius in kilometers
  EARTH_RADIUS = 6371

  def distance_between(lat1, lon1, lat2, lon2)
    # Convert degrees to radians
    rad_lat1 = deg_to_rad(lat1)
    rad_lat2 = deg_to_rad(lat2)
    rad_lon1 = deg_to_rad(lon1)
    rad_lon2 = deg_to_rad(lon2)
  
    dlon = rad_lon2 - rad_lon1
    dlat = rad_lat2 - rad_lat1
  
    a = Math.sin(dlat / 2) * Math.sin(dlat / 2) +
        Math.cos(rad_lat1) * Math.cos(rad_lat2) *
        Math.sin(dlon / 2) * Math.sin(dlon / 2)
  
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  
    distance = EARTH_RADIUS * c
  
    return distance
  end

  #  Function to convert degrees to radians
  def deg_to_rad(degrees)
    degrees * Math::PI / 180
  end
end
