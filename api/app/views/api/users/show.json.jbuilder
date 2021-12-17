if @user
  json.user do
    json.extract! @user, :id, :myid, :name, :address, :image, :wanted, :sex, :age, :year, :profile, :created_at
  end
end

# objectをArrayに包む
json.target_skills do
  json.array! @skills, :id, :name
end

json.target_times do
  json.array! @free_times, :id, :start_time, :finish_time
end

json.requests do
  json.array! @requests do |request|
    json.id request.id
    json.start_time request.start_time
    json.finish_time request.finish_time
    json.partner request.recruitment_time.host
  end
end

json.agreements do
  json.array! @agreements, :id, :room, :host, :state, :start_time, :finish_time
end

json.offers do
  json.array! @offers do |request|
    json.id request.id
    json.start_time request.start_time
    json.finish_time request.finish_time
    json.free_time request.free_time
    json.partner request.host
  end
end

json.rooms do
  json.array! @rooms, :id, :state, :closed, :user, :host, :created_at
end