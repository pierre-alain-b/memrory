require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  validate :password_non_blank
  
  after_destroy :check_if_not_last_user
  
	# Compares a typed password with the hash stored in the database for a the user whose name is specified in the 'name' parameter
	def self.authenticate(name, password)
		user = self.find_by_name(name)
		if user
			comparison_password=encrypted_password(password, user.salt)
			if user.hashed_password != comparison_password
				user = nil
			end
		end
		user
	end
	
	# Idem as self.authenticate but relies on the id for the user
	def self.authenticate_id(id, password)
		user = self.find_by_id(id)
		if user
			comparison_password=encrypted_password(password, user.salt)
			if user.hashed_password != comparison_password
				user = nil
			end
		end
		user
	end
	
	# Returns the password
	def password
		@password	
	end
	
	# Writes the password in a clever way : generates the salt and writes only the hash
	def password=(pwd)
		@password=pwd
		return if pwd.blank?
		create_new_salt
		self.hashed_password = User.encrypted_password(self.password, self.salt)
	end
  
  def check_if_not_last_user
    if User.count.zero?
      raise "Can't delete last user"
    end
  end
	  
  private
  
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end
  
	# Returns the encrypted password
	def self.encrypted_password(password, salt)
		string_to_hash = password + "mon-petit-sel-pour-mon-cerveau" + salt
		Digest::SHA1.hexdigest(string_to_hash)
	end
	
	# Creates a new (supposedly random) salt
	def create_new_salt
		self.salt = self.object_id.to_s + rand.to_s
  end  
  
end
