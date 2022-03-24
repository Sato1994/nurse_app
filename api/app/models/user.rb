# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  include DeviseTokenAuth::Concerns::User

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  has_many :agreements, dependent: :destroy
  has_many :hosts, through: :agreements
  has_many :free_times, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  has_many :host_requests, through: :free_times
  has_many :recruitment_times, through: :user_requests
  has_many :rooms, dependent: :destroy
  has_many :user_messages, through: :rooms
  has_many :cancell_comments, through: :agreements

  mount_uploader :image, ImageUploader

  # 個人のページのURLをmyidにする。
  def to_param
    myid
  end

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :wanted, exclusion: { in: [nil] } # #presence: trueは内部でblank?メゾットを使用するためbooleanには合わない。
  # validates :sex
  # validates :address
  # validates :image
  validates :profile, length: { maximum: 300 }
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 20, less_than_or_equal_to: 60, allow_nil: true }
  validates :year, numericality: { only_integer: true, less_than: 40, allow_nil: true }
  validates :myid, presence: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { maximum: 15 },
                   uniqueness: { case_sensitive: true }
  # ##issue#5###
  # validates :password, presence: true, confirmation: true, length: { in: 8..20 }
  # validates :password_confirmation, presence: true

  scope :year_gt, ->(lower_year) { where('year >= ?', lower_year) if lower_year.present? }
  scope :address_like, ->(address) { where('address LIKE ?', "%#{address}%") if address.present? }
  scope :wanted_true, ->(wanted) { where(wanted: true) if wanted.present? }
  scope :id_include, ->(ids, params) { where(id: ids) if ids.present? && params.present? }
end
