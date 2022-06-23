class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token, :api_token
  CSV_ATTRIBUTES = %w(name age phone email date_of_birth gender).freeze
  require 'csv'

  has_many :likes, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name, foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name, foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :microposts, dependent: :destroy
  has_many :user_shops
  has_many :comments, dependent: :destroy
  has_many :shops, through: :user_shops, foreign_key: 'shops_id'

  validates :name, length: {minimum: 1, maximum: 100}, presence: true
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, uniqueness:true, presence: true, format: { with: valid_email_regex }
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  has_secure_password

  before_save :downcase_email
  before_create :create_activation_digest
  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest(string)
      cost = 
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def import_file(file) 
      CSV.foreach(file.path, headers: true) do |row|
        User.create!(row.to_hash)
      end
    end
  end

  def follow other_user #Follows a user.
    following << other_user
  end

  def unfollow other_user #Unfollows a user.
    following.delete other_user
  end

  def following? other_user #Returns if the current user is following the other_user or not
    following.include? other_user
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  # Activates an account.
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #reset password
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 1.hours.ago
  end

  def feed
    microposts
  end

  def follow other_user #Follows a user.
    following << other_user
  end

  def unfollow other_user #Unfollows a user.
    following.delete other_user
  end

  def following? other_user #Returns if the current user is following the other_user or not
    following.include? other_user
  end

  def generate_token
    self.api_token = User.new_token
    self.update_attribute(:api_token_digest, api_token)
  end

  private
  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
