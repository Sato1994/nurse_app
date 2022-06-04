# frozen_string_literal: true

class Host < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  include DeviseTokenAuth::Concerns::User

  has_many :host_skills, dependent: :destroy
  has_many :skills, through: :host_skills
  has_many :agreements, dependent: :destroy
  has_many :users, through: :agreements
  has_many :recruitment_times, dependent: :destroy
  has_many :host_requests, dependent: :destroy
  has_many :user_requests, through: :recruitment_times
  has_many :free_times, through: :host_requests
  has_many :rooms, dependent: :destroy
  has_many :host_messages, through: :rooms
  has_many :rates, through: :agreements
  has_many :host_notices, dependent: :destroy

  mount_uploader :image, ImageUploader

  attribute :distance, type: String
  attribute :rate_average, type: String
  attribute :rate_count, type: Integer

  def to_param
    myid
  end

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :phone, presence: true, length: { maximum: 13 }
  validates :wanted, exclusion: { in: [nil] }
  validates :profile, length: { maximum: 300 }
  validates :myid, presence: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { maximum: 15 },
                   uniqueness: { case_sensitive: true }

  scope :name_like, ->(name) { where('name LIKE ?', "%#{name}%") if name.present? }
  scope :address_like, ->(address) { where('address LIKE ?', "%#{address}%") if address.present? }
  scope :wanted_true, ->(wanted) { where(wanted: true) if wanted.present? }
  scope :id_include, ->(ids, params) { where(id: ids) if ids.present? && params.present? }

  def star_average
    stars_sum = 0
    # プロを目指すためのruby p95 Short blocks are easier to read if they are replaced with {}'s.
    rates.each { |rate| stars_sum += rate.star }
    rate_average = if rates.count.zero?
                     0
                   else
                     (stars_sum / rates.count.to_f).round(1)
                   end
  end

  def soft_delete
    transaction do
      update_attribute(:name, '退会したユーザー')
      update_attribute(:wanted, false)
      update_attribute(:deleted_at, Time.current)
      recruitment_times.destroy_all
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

  def render_host
    as_json(
      only: %i[id myid name address lat lng image wanted phone profile created_at rate_count rate_average]
    )
  end

  def render_agreements
    render_agreements = agreements.in_progress.order(:start_time).as_json(
      only: %i[id start_time finish_time state],
      include: {
        room: {
          only: %i[id]
        },
        user: {
          only: %i[name myid]
        }
      }
    )

    change_property_to_partner render_agreements
  end

  def render_rooms
    render_rooms = rooms
                   .host_have_not_exited
                   .related_agreement_is_not_in_progress
                   .order(:start_time)
                   .as_json(
                     only: %i[id state closed start_time finish_time created_at],
                     include: {
                       user: {
                         only: %i[id name]
                       }
                     }
                   )

    change_property_to_partner render_rooms
  end

  def render_host_requests
    render_host_requests = host_requests.order(:start_time).as_json(
      only: %i[id start_time finish_time],
      include: {
        user: {
          only: %i[id name image myid]
        }
      }
    )

    change_property_to_partner render_host_requests
  end

  def render_user_requests
    render_user_requests = user_requests.order(:start_time).as_json(
      only: %i[id start_time finish_time],
      include: {
        user: {
          only: %i[id name image myid]
        }
      }
    )

    change_property_to_partner render_user_requests
  end

  def render_host_notices
    render_host_notices = host_notices.order(created_at: :desc).as_json(
      only: %i[action checked created_at id source_id source_type],
      include: {
        source: {
          only: [],
          include: {
            user: {
              only: %i[name myid image]
            }
          }
        }
      }
    )

    render_host_notices.each do |notice|
      notice['source']['partner'] = notice['source'].delete('user')
      if notice['source_type'] === 'Agreement'
        notice['source']['room'] = { id: host_notices.find(notice['id']).source.room.id }
      end
    end
  end

  def render_recruitment_times
    recruitment_times.order(:start_time).as_json(
      only: %i[id start_time finish_time]
    )
  end

  def render_host_skills
    skills.as_json(
      only: %i[id name]
    )
  end

  def change_property_to_partner(resources)
    resources.each do |resource|
      resource['partner'] = resource.delete('user')
    end
  end
end
