json.host do
  json.extract! @host, :myid, :name, :address, :image, :wanted, :profile, :created_at
end

json.target_skills do
  json.array! @skills, :id, :name
end