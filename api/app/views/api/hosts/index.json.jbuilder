json.array! @hosts do |host|
  json.name host.name
  json.address host.address
  json.image host.image
  json.profile host.profile
end