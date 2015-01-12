class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
	:first_name, :last_name, :phone_number_1, :phone_number_2, 
	:address_line_1, :address_line_2
  # attr_accessible :title, :body
  
  self.inheritance_column = :user_type
  
  attr_protected
end
