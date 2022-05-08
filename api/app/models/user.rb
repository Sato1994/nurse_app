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
  has_many :rates, through: :agreements
  has_many :user_notices, dependent: :destroy

  mount_uploader :image, ImageUploader
  # geocoded_by :address, latitude: :lat, longitude: :lng
  # after_validation :geocode

  def to_param
    myid
  end

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :wanted, exclusion: { in: [nil] }
  validates :profile, length: { maximum: 300 }
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 20, less_than_or_equal_to: 60, allow_nil: true }
  validates :year, numericality: { only_integer: true, less_than: 40, allow_nil: true }
  validates :myid, presence: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { maximum: 15 },
                   uniqueness: { case_sensitive: true }

  scope :year_gt, ->(lower_year) { where('year >= ?', lower_year) if lower_year.present? }
  scope :address_like, ->(address) { where('address LIKE ?', "%#{address}%") if address.present? }
  scope :wanted_true, ->(wanted) { where(wanted: true) if wanted.present? }
  scope :id_include, ->(ids, params) { where(id: ids) if ids.present? && params.present? }

  def soft_delete
    transaction do
      update_attribute(:name, '退会したユーザー')
      update_attribute(:wanted, false)
      update_attribute(:deleted_at, Time.current)
      free_times.destroy_all
      user_requests.destroy_all
      host_requests.destroy_all
    end
  end

  def active_for_authentication?
    super && !deleted_at
  end

  def valid_agreements_exists?
    agreements.exists?(state: %i[before during requesting])
  end

  def valid_rooms_exists?
    rooms.exists?(state: %i[negotiating user host conclusion])
  end

  def render_user
    as_json(
      only: %i[id myid name address lat lng image wanted sex age year profile created_at]
    )
  end

  def render_agreements
    render_agreements = agreements.order(:start_time).in_progress.as_json(
      only: %i[id start_time finish_time state],
      include: {
        room: {
          only: %i[id]
        },
        host: {
          only: %i[name myid phone]
        }
      }
    )

    render_agreements.each do |agreement|
      agreement['partner'] = agreement.delete('host')
    end
  end

  def render_rooms
    render_rooms =
      rooms.user_have_not_exited
           .related_agreement_is_not_in_progress
           .order(:start_time)
           .as_json(
             only: %i[id state closed start_time finish_time created_at],
             include: {
               host: {
                 only: %i[id name]
               }
             }
           )

    render_rooms.each do |room|
      room['partner'] = room.delete('host')
    end
  end

  def render_user_requests
    render_user_requests = user_requests.order(:start_time).as_json(
      only: %i[id start_time finish_time],
      include: {
        host: {
          only: %i[id name image myid]
        }
      }
    )
    render_user_requests.each do |request|
      request['partner'] = request.delete('host')
    end
  end

  def render_host_requests
    render_host_requests = host_requests.order(:start_time).as_json(
      only: %i[id start_time finish_time],
      include: {
        host: {
          only: %i[id name image myid]
        }
      }
    )

    render_host_requests.each do |request|
      request['partner'] = request.delete('host')
    end
  end

  def render_user_notices
    render_user_notices = user_notices.order(created_at: :desc).as_json(
      only: %i[action checked created_at id source_id source_type],
      include: {
        source: {
          only: [],
          include: {
            host: {
              only: %i[name myid image]
            }
          }
        }
      }
    )

    render_user_notices.each do |notice|
      notice['source']['partner'] = notice['source'].delete('host')
      if notice['source_type'] === 'Agreement'
        notice['source']['room'] = { id: @resource.user_notices.find(notice['id']).source.room.id }
      end
    end
  end

  def render_free_times
    free_times.order(:start_time).as_json(
      only: %i[id start_time finish_time]
    )
  end

  def render_user_skills
    skills.as_json(
      only: %i[id name]
    )
  end
end
