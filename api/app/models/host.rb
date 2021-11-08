# frozen_string_literal: true

class Host < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  include DeviseTokenAuth::Concerns::User

  has_many :host_skills, dependent: :destroy
  has_many :skills, through: :host_skills
  has_many :agreements, dependent: :destroy
  has_many :users, through: :agreements
  has_many :recruitment_times, dependent: :destroy
  has_many :host_requests, dependent: :destroy
  has_many :free_times, through: :host_requests
  has_many :rooms, dependent: :destroy
  has_many :host_messages, through: :rooms

  def to_param
    myid
  end

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  # validates :address,
  # validates :image,
  validates :wanted, exclusion: { in: [nil] }
  validates :profile, length: { maximum: 300 }
  validates :myid, presence: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { maximum: 15 }, uniqueness: { case_sensitive: true }
end
