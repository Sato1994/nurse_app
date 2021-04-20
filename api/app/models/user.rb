# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  include DeviseTokenAuth::Concerns::User

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :wanted, exclusion: { in: [nil] } ##presence: trueは内部でblank?メゾットを使用するためbooleanには合わない。
  # validates :sex
  # validates :address
  # validates :image
  validates :profile, length: { maximum: 150 }
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 20, less_than_or_equal_to: 60, allow_nil: true }
  validates :year, numericality: { only_integer: true, less_than: 40, allow_nil: true }
  ###issue#5###
  # validates :password, presence: true, confirmation: true, length: { in: 8..20 }
  # validates :password_confirmation, presence: true
end
