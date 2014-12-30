class Customer < ActiveRecord::Base
	attr_accessible :name, :address, :phone_number, :active
	
	validates :name, presence: true
	validates :phone_number, presence: true
	
	has_many :invoices
	has_many :customer_bills
	has_many :customer_vehicles
	
	scope :active_customers, lambda { where({active: true}) }
	default_scope lambda{ order("active") }
	
	def generate_invoice
		pending_bills = customer_bills.bills_in_draft
		return nil if pending_bills.empty?
		invoice = invoices.build
		puts "#####"
		puts invoice.inspect
		invoice.customer_bills = pending_bills
		pending_bills.each{|pb| pb.mark_as_invoiced! }
		invoice.save!		
	end
	
	def self.generate_balance_report
		
	end
	
	def to_pdf
		file_content = Jasper::Rails.render_pdf("#{Rails.root}/app/views/reports/customer_balance_report.jasper", self, {}, {})
		file = File.open("#{tempfile}.pdf", "w")
		file.binmode
		file.write(file_content)
		file.close
		File.absolute_path(file)
	end
	
	def bunk_name
		"Shree Ankanatheshwara Fuel Service Station"
	end
	
	def bunk_address1
		"Dealers in : Indian oil Corporation Ltd. (KSK)"
	end
	
	def bunk_address2
		"Maddur Main Road, KOPPA- 571425"
	end
	
	def contact1
		"9880200411, 9449078411"
	end
	
	def printed_date
		Date.current.stftime("%d/%m/%Y")
	end
	
	def balance
	
	end
	
	def customers
		Customer.active_customers.collect do |cust|
			{name: cust.name, 
			address: cust.address, 
			phone_number: cust.phone_number,
			customer_balance: cust.balance
			}
		end
	end
	
	def to_xml(options = {})
		options[:methods] = [
			:bunk_name,
			:printed_date,
			:bunk_address1,
			:bunk_address2,
			:contact1,
			:customers			
		]
		super options
	end
end
