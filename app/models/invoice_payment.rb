class InvoicePayment < ActiveRecord::Base
	attr_accessible :customer_id, :invoice_id, :amount_paid, :paid_date
	
	belongs_to :invoice
	belongs_to :customer
	
	validates :customer_id, :presence => true
	validates :invoice_id, :presence => true
	validates :amount_paid, :presence => true
	validates :paid_date, :presence => true
end
