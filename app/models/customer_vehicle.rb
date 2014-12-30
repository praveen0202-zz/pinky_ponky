class CustomerVehicle < ActiveRecord::Base

	attr_accessible :customer_id, :vehicle_type_id, :vehicle_number
	
	belongs_to :customer
	belongs_to :vehicle_type
	
	validates :customer, presence: true
	validates :vehicle_type, presence: true
	validates :vehicle_number, presence: true
	
end
