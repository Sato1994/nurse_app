json.host do
  json.extract! @host, :id, :myid, :name, :address, :image, :wanted, :profile, :created_at
end

json.target_skills do
  json.array! @skills, :id, :name
end

json.target_times do
  json.array! @recruitment_times, :id, :start_time, :finish_time
end