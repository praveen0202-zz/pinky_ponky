class CustomerBill < ActiveRecord::Base
	
	attr_accessible :bill_number, :bill_date, :quantity, :bill_amount, :status, :customer_id, :product_id, :customer_vehicle_id, :product_price_id
	
	belongs_to :customer
	belongs_to :product
	belongs_to :customer_vehicle
	belongs_to :product_price
	belongs_to :invoice
	
	validates :customer, presence: true
	validates :product, presence: true
	validates :customer_vehicle, presence: true
	validates :product_price, presence: true
	validates :bill_number, presence: true
	validates :bill_date, presence: true
	validates :quantity, presence: true
	validates :bill_amount, presence: true
	
	scope :bills_in_draft, lambda { where(["status = ?", 'D']) }
	
	STATE_MAP = {:draft => 'D', :invoiced => 'I', :partially_paid => 'R', :paid => 'P'}
	
	include AASM

	aasm :column => :status do
		state :draft, :initial => true
		state :invoiced
		state :partially_paid
		state :paid

		event :mark_as_invoiced do
			transitions :from => :draft, :to => :invoiced
		end

		event :mark_as_partially_paid do
			transitions :from => :invoiced, :to => :partially_paid
			transitions :from => :partially_paid, :to => :partially_paid
		end

		event :mark_as_paid do
			transitions :from => :partially_paid, :to => :paid
		end
	end
	
		alias_method :write_attribute_without_mapping, :write_attribute
	def write_attribute(attr, v)
		v = STATE_MAP[v.to_sym] if attr.to_sym == :status
		write_attribute_without_mapping(attr, v)
	end
	  
	def status
		STATE_MAP.invert[read_attribute(:status)]
	end
	
	def bill_date_display
		bill_date.strftime("%d/%m/%Y")
	end

end
