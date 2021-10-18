json.user do
  json.extract! @user, :id, :myid, :name, :address, :image, :wanted, :sex, :age, :year, :profile, :created_at
end

# objectをArrayに包む
json.target_skills do
  json.array! @skills, :id, :name
end

json.target_times do
  json.array! @free_times, :id, :start_time, :finish_time
end

json.requests do
  json.array! @requests, :id, :start_time, :finish_time, :user, :host
end

json.agreements do
  json.array! @agreements, :id, :start_time, :finish_time
end

