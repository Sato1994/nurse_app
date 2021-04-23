json.array! @users do |user|
  json.name user.name
  json.address user.address
  json.age user.age
  json.sex user.sex
  json.year user.year
  json.image user.image
  json.profile user.profile
end