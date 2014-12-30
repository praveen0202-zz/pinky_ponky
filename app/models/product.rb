class Product < ActiveRecord::Base
	attr_accessible :product_name
	
	has_many :product_prices
	has_many :bills
	
	validates :product_name, presence: true
end
