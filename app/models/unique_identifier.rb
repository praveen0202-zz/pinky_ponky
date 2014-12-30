class UniqueIdentifier < ActiveRecord::Base
	attr_accessible :identifier, :identifier_type
 	
	def self.get_uniq_number(type)
		uniq_identifier = self.where({identifier_type: type}).first
		identifier = (uniq_identifier.identifier.to_i + 1).to_s
		uniq_identifier.identifier = identifier
		uniq_identifier.save!
		identifier
	end
end
