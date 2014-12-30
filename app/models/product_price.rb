class ProductPrice < ActiveRecord::Base
	attr_accessible :rate, :effective_from, :effective_to, :product_id
	
	belongs_to :product
	has_many :bills
	
	validates :product, presence: true
	validates :rate, presence: true
	validates :effective_from, presence: true
end
