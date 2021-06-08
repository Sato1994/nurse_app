json.user do
  json.extract! @user, :myid, :name, :address, :image, :wanted, :sex, :age, :year, :profile, :created_at
end

json.target_skills do
  json.array! @skills, :id, :name
end