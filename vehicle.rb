class Vehicle < ActiveRecord::Base
  has_many :vehicle_usages
end
