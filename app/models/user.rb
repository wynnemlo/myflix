class User < ActiveRecord::Base
  validates_presence_of :email, :password_digest, :full_name

  validates_uniqueness_of :email
  
  has_secure_password

  has_many :reviews
end