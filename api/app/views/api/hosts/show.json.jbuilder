if @host
  json.info do
    json.extract! @host, :id, :myid, :name, :address, :image, :wanted, :profile, :created_at
  end
end

json.skills do
  json.array! @skills, :id, :name
end

json.times do
  json.array! @recruitment_times, :id, :start_time, :finish_time
end

json.requests do
  json.array! @requests do |request|
    json.id request.id
    json.start_time request.start_time
    json.finish_time request.finish_time
    json.partner request.free_time.user
  end
end

json.agreements do
  json.array! @agreements, :id, :room, :user, :state, :start_time, :finish_time
end

json.offers do
  json.array! @offers do |request|
    json.id request.id
    json.start_time request.start_time
    json.finish_time request.finish_time
    json.recruitment_time request.recruitment_time
    json.partner request.user
  end
end

json.rooms do
  json.array! @rooms, :id, :state, :closed, :user, :host, :created_at
end