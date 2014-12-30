class VehicleType < ActiveRecord::Base
	attr_accessible :vehicle_name
	
	has_many :bills
	
	validates :vehicle_name, presence: true

end
