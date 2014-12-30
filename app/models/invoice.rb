require 'jasper-rails'
class Invoice < ActiveRecord::Base
	include JasperRails
	attr_accessible :customer_id, :invoice_date, :invoice_amount, :invoice_number, :total_invoice_amount, :previous_invoice_amount, :previous_invoice_paid_amount, :invoice_closed, :previous_invoice_pending_amount
	
	has_many :customer_bills
	belongs_to :customer
	
	validates :customer_id, :presence => true
	validates :invoice_date, :presence => true
	
	before_create :close_previous_invoice
	after_initialize :set_defaults
	
	scope :not_closed_invoices, lambda { where({invoice_closed: false}) }
	
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
	
	def self.previous_invoice(invoice)
	puts "@@@@@@@@@"
	puts invoice.inspect
		not_closed_invoices.where({customer_id: invoice.customer_id}).first
	end
	
	def remaing_amount
		@amount_remaining = invoice_amount - amount_paid
	end
	
	def paid_amount
		@amount_paid ||= self.invocie_payments.map(&:amount_paid).sum
	end
	
	def bill_amounts
		self.customer_bills.map(&:bill_amount).sum
	end
	
	def bunk_name
		"Shree Ankanatheshwara Fuel Service Station"
	end
	
	def bunk_address
		"Maddur Main Road, Koppa, Mandya - 571425"
	end
	
	def contact1
		"9880200411, 9449078411"
	end
	
	def customer_name
		customer.name
	end
	
	def to_pdf
		file_content =  Jasper::Rails.render_pdf("#{Rails.root}/app/views/reports/invoice.jasper", self, {}, {})
		file = File.open("#{tempfile}.pdf", "w")
		file.binmode
		file.write(file_content)
		file.close
		File.absolute_path(file)
	end
	
	def self.pdf_url(invoice_ids)
		invoices = where({id: invoice_ids})
		if invoices.size == 1
			invoices.last.to_pdf
		else
			pdfs = invoices.collect{|invoice| invoice.to_pdf }
			combined_pdf_files(pdfs)
		end
    end
	
	def bills
		list = []
		customer_bills.each do |bill|
			list << {	product_name: bill.product.product_name, 
				bill_number: bill.bill_number,
				indent_number: bill.indent_number,
				indent_number: bill.indent_number,
				vehicle_number: bill.customer_vehicle.vehicle_number,
				bill_date: bill.bill_date_display,
				rate: bill.product_price.rate,
				quantity: bill.quantity,
				group_column: "1",
				bill_amount: bill.bill_amount
			}
		end
		puts "@###$$#@#$#@@@"
		puts list
		list
	end
	
	def invoice_date_display
		invoice_date.strftime("%d/%m/%Y")
	end
	
	def to_xml(options = {})
		options[:methods] = [
			:bunk_name,
			:customer_name,
			:bunk_address,
			:contact1,
			:invoice_date_display,
			:bills,
			:total_amount_in_words			
		]
		super options
	end
	
	def total_amount_in_words
		rupee, paise = total_invoice_amount.to_s.split('.')
		(I18n.with_locale(:en) { rupee.to_i.to_words } + " rupees and " + I18n.with_locale(:en) { paise.to_i.to_words } + " paise only.").titleize
	end
	
	private
	
	def close_previous_invoice
		previous_invoice = Invoice.previous_invoice(self)
		puts "4444444444"
		puts self.inspect
		puts previous_invoice.inspect
		self.invoice_number = UniqueIdentifier.get_uniq_number("Invoice")
		puts "@#@#@#@#@#"
		self.invoice_amount = bill_amounts
		if previous_invoice.present?
			self.total_invoice_amount = invoice_amount + previous_invoice.remaing_amount
			self.previous_invoice_amount = previous_invoice.invoice_amount
			self.previous_invoice_paid_amount = previous_invoice.paid_amount
			self.previous_invoice_pending_amount = previous_invoice.remaing_amount
			previous_invoice.update_attribute(:invoice_closed, true)
		else
			self.total_invoice_amount = invoice_amount + 0
			self.previous_invoice_amount = 0
			self.previous_invoice_paid_amount = 0
			self.previous_invoice_pending_amount = 0
		end
	end
	
	def set_defaults
		self.invoice_date = Date.current
	end

end
