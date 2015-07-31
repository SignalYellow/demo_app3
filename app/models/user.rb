class User < ActiveRecord::Base
	
	has_many :microposts, dependent: :destroy
	#db may save email by lowercase
	before_save {self.email = email.downcase }
	before_create :create_remember_token
	
	#validate name's presence and length within 50 characters
	validates :name, presence: true , length: {maximum:50 }
	
	#validate email by regex and presence and uniquness
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	
	#password management
	has_secure_password
	
	#validate password longer than 5 characters
	validates :password, length: {minimum: 6}

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  #create hash
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
	Micropost.where("user_id = ?", id)
  end

	


  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
