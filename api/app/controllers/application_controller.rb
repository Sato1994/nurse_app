# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def user_login_and_own?(id)
    api_user_signed_in? && current_api_user.id == id
  end

  def host_login_and_own?(id)
    api_host_signed_in? && current_api_host.id == id
  end

  def render_message(message, status)
    render json: { message: [message] }, status: status
  end

  def calc_distance(hosts)
    x1 = current_api_user.lat.to_f * Math::PI / 180
    y1 = current_api_user.lng.to_f * Math::PI / 180

    hosts.each do |host|
      x2 = host[:lat].to_f * Math::PI / 180
      y2 = host[:lng].to_f * Math::PI / 180

      redius = 6378.137

      diff_y = (y1 - y2).abs

      calc1 = Math.cos(x2) * Math.sin(diff_y)
      calc2 = (Math.cos(x1) * Math.sin(x2)) - (Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y))

      numerator = Math.sqrt((calc1**2) + (calc2**2))
      denominator = (Math.sin(x1) * Math.sin(x2)) + (Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y))
      degree = Math.atan2(numerator, denominator)

      distance = degree * redius

      host.distance = distance.round(1)
    end
  end

  def rate_average(hosts)
    hosts.each do |host|
      stars_sum = 0

      count = host.rates.count
      host.rate_count = count

      host.rates.each do |rate|
        stars_sum += rate.star
      end

      rate_average = if count.zero?
                       0
                     else
                       (stars_sum / count.to_f).round(1)
                     end

      host.rate_average = rate_average
    end
  end
end
