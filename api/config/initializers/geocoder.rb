# frozen_string_literal: true
if Rails.env.production?
  Geocoder.configure(
    lookup: :google,
    always_raise: [
      Geocoder::OverQueryLimitError,
      Geocoder::RequestDenied,
      Geocoder::InvalidRequest,
      Geocoder::InvalidApiKey
    ],
    api_key: ENV['MAPS_API_KEY'],
    use_https: true
  )
else
end