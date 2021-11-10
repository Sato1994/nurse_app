json.host do
  json.extract! @host, :id, :myid, :name, :address, :image, :wanted, :profile, :created_at
end

json.target_skills do
  json.array! @skills, :id, :name
end

json.target_times do
  json.array! @recruitment_times, :id, :start_time, :finish_time
end

json.requests do
  json.array! @requests do |request|
    json.id request.id
    json.start_time request.start_time
    json.finish_time request.finish_time
    json.user request.free_time.user
  end
end

json.agreements do
  json.array! @agreements, :id, :start_time, :finish_time
end

json.offers do
  json.array! @offers, :id, :start_time, :finish_time, :user, :recruitment_time
end

json.rooms do
  json.array! @rooms, :id, :user, :host, :created_at
end