class SalesPerson < User

	before_validation :set_defaults, :if => :new_record?
	
	private
	
	def set_defaults
	  self.email = first_name + last_name + "#{rand(100000)}" + "@gmail.com" unless email
	  unless password
			self.password = "test1234"
			self.password_confirmation = "test1234"
		end
	end
	
end
