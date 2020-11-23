class User < ApplicationRecord
  # リレーション
  has_many :products
  has_many :user_likes
  has_secure_password
  
  mount_uploader :image, ImageUploader

  # バリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A[a-zA-Z0-9]+\z/
  validates :name, presence: true
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: true,  on: :create
  validates :password, presence: true, length:{minimum: 8}, format: {with: VALID_PASSWORD_REGEX}, on: :create
  validates :password, allow_blank: true, length:{minimum: 8}, format: {with: VALID_PASSWORD_REGEX}, on: :update

end