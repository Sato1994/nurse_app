json.host do
  json.extract! @host, :myid, :name, :address, :image, :wanted, :profile, :created_at
end

json.skills do
  json.array! @skills, :name
end