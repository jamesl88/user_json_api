class User < ActiveRecord::Base
  include SoftDeletable
  attr_accessor :password
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :password
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  before_create :encrypt_password

  default_scope { where(deleted_at: nil) }

  def encrypt_password
    if self.password.blank?
      errors.add(:password, "can't be blank")
    else
      self.salt = SecureRandom.hex
      self.encrypted_password = Digest::SHA1.hexdigest("Add #{salt} to #{password}")
    end
  end
end
