json.array! @hosts do |host|
  json.name host.name
  json.address host.address
  json.image host.image
  json.profile host.profile
  json.id host.id
  json.uid host.uid
end