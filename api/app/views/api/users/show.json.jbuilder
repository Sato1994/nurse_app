if @user
  json.info do
    json.extract! @user, :id, :myid, :name, :address, :lat, :lng, :image, :wanted, :sex, :age, :year, :profile, :created_at
  end
end

# objectをArrayに包む
json.skills do
  json.array! @skills, :id, :name
end

json.times do
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
  json.array! @agreements do |agreement|
    json.id agreement.id
    json.room agreement.room
    json.partner agreement.host
    json.state agreement.state
    json.start_time agreement.start_time
    json.finish_time agreement.finish_time
  end
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
  json.array! @rooms do |room|
    json.id room.id
    json.state room.state
    json.closed room.closed
    json.partner room.host
    json.start_time room.start_time
    json.finish_time room.finish_time
    json.created_at room.created_at
  end
end