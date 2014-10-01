class User < ActiveRecord::Base
  attr_reader :password

  after_initialize :set_session_token

  validates_presence_of :user_name, :password_digest
  validates_uniqueness_of :user_name, :session_token

  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :cats, :dependent => :destroy
  has_many :cat_rental_requests

  def self.find_by_credentials(user_params)
    user = User.find_by(user_name: user_params[:user_name])
    return user if user.is_password?(user_params[:password])

    nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    st = SecureRandom::urlsafe_base64(16)
    self.session_token = st
    self.save!
    st
  end

  private
  def set_session_token
    st = SecureRandom::urlsafe_base64(16)
    self.session_token ||= st
    self.save!
    self.session_token
  end
end
